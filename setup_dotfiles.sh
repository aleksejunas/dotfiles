#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Diagnose how Hyprland and Waybar connect.
diagnose() {
  set +e
  WAYBAR_DIR="$HOME/.config/waybar"
  HYPR_WAYBAR_DIR="$HOME/.config/hypr/waybar"

  echo "Session:"
  echo "  XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unknown}"
  echo "  XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unknown}"
  echo "  XDG_SESSION_DESKTOP=${XDG_SESSION_DESKTOP:-unknown}"
  if pgrep -x Hyprland >/dev/null; then
    echo "Compositor: Hyprland (running)"
  else
    echo "Compositor: Hyprland not running"
  fi

  echo "Waybar processes:"
  pgrep -a waybar || echo "  none"

  CONFIG_FROM_PROC=$(pgrep -a waybar | awk 'match($0, /( --config|-c)[ =]([^ ]+)/, a){print a[2];exit}')
  STYLE_FROM_PROC=$(pgrep -a waybar | awk 'match($0, /( --style|-s)[ =]([^ ]+)/, a){print a[2];exit}')

  CONF_DEFAULT="$WAYBAR_DIR/config.jsonc"
  [[ -f "$CONF_DEFAULT" ]] || CONF_DEFAULT="$WAYBAR_DIR/config"
  STYLE_DEFAULT="$WAYBAR_DIR/style.css"

  ACTIVE_CONFIG="${CONFIG_FROM_PROC:-$CONF_DEFAULT}"
  ACTIVE_STYLE="${STYLE_FROM_PROC:-$STYLE_DEFAULT}"

  echo "Active Waybar config: ${ACTIVE_CONFIG:-unknown}"
  echo "Active Waybar style:  ${ACTIVE_STYLE:-unknown}"

  HYPR_STYLE="$HYPR_WAYBAR_DIR/style.css"
  if [[ -L "$HYPR_STYLE" ]]; then
    echo "Hypr style path is a symlink:"
    echo "  $HYPR_STYLE -> $(readlink -f "$HYPR_STYLE" 2>/dev/null)"
  elif [[ -e "$HYPR_STYLE" ]]; then
    echo "Hypr style path is a regular file:"
    echo "  $HYPR_STYLE"
  else
    echo "Hypr style path does not exist:"
    echo "  $HYPR_STYLE"
  fi

  echo "Hypr config references to Waybar:"
  grep -RniE 'exec(-once)?\s*=.*waybar|(^|\s)waybar(\s|$)' "$HOME/.config/hypr" 2>/dev/null | head -n 10 || echo "  none found"

  echo "Summary:"
  if [[ -n "$CONFIG_FROM_PROC" ]]; then
    echo "  Waybar launched with --config -> $CONFIG_FROM_PROC"
  else
    echo "  Waybar using default config -> $CONF_DEFAULT"
  fi
  if [[ -n "$STYLE_FROM_PROC" ]]; then
    echo "  Waybar launched with --style  -> $STYLE_FROM_PROC"
  else
    echo "  Waybar using default style  -> $STYLE_DEFAULT"
  fi
  echo "  Preferred layout: ~/.config/hypr/waybar/style.css -> ~/.config/waybar/style.css (symlink)"
  set -e
}

# Hypr-only diagnosis: shows config tree, exec/exec-once, bind execs, and scripts usage.
diagnose_hypr() {
  set +e
  HYPR_DIR="$HOME/.config/hypr"
  ROOT_CONF="$HYPR_DIR/hyprland.conf"
  SCRIPTS_DIR="$HYPR_DIR/scripts"

  echo "Hypr config root:"
  if [[ -f "$ROOT_CONF" ]]; then
    echo "  $ROOT_CONF"
  else
    echo "  not found (looked for $ROOT_CONF)"
  fi

  echo "Included configs (source/include):"
  grep -RniE '^\s*(source|include)\s*=' "$HYPR_DIR" 2>/dev/null | sed 's/^/  /' || echo "  none"

  echo "Autostart (exec/exec-once) commands:"
  grep -RniE '^\s*exec(-once)?\s*=' "$HYPR_DIR" 2>/dev/null | sed 's/^/  /' || echo "  none"

  echo "Keybind execs (bind ... ,exec, ...):"
  grep -RniE '^\s*bind.*,\s*exec\s*,' "$HYPR_DIR" 2>/dev/null | sed 's/^/  /' || echo "  none"

  echo "Scripts directory:"
  if [[ -d "$SCRIPTS_DIR" ]]; then
    for f in "$SCRIPTS_DIR"/*; do
      [[ -e "$f" ]] || continue
      b="$(basename "$f")"
      ref_count=$(grep -RIl -- "$b" "$HYPR_DIR" 2>/dev/null | wc -l | tr -d ' ')
      exec_flag="no"; [[ -x "$f" ]] && exec_flag="yes"
      echo "  $f (exec=$exec_flag, referenced=$ref_count)"
    done
  else
    echo "  $SCRIPTS_DIR (not found)"
  fi

  echo "Summary:"
  echo "  - Hypr reads hyprland.conf, then any files listed via source/include."
  echo "  - Autostart apps/scripts via exec/exec-once lines."
  echo "  - Keybinds trigger shell commands via bind ...,exec,... lines."
  echo "  - Common pattern: put scripts in $SCRIPTS_DIR and reference them from exec/bind."
  set -e
}

# Hypr scripts diagnosis: maps each script in ~/.config/hypr/scripts to its config references.
diagnose_hypr_scripts() {
  set +e
  HYPR_DIR="$HOME/.config/hypr"
  SCRIPTS_DIR="$HYPR_DIR/scripts"

  echo "Hypr scripts mapping:"
  if [[ ! -d "$SCRIPTS_DIR" ]]; then
    echo "  $SCRIPTS_DIR (not found)"
    set -e
    return
  fi

  shopt -s nullglob
  for f in "$SCRIPTS_DIR"/*; do
    [[ -e "$f" ]] || continue
    b="$(basename "$f")"
    echo "---- $b ----"
    echo "Path: $f"
    if [[ -x "$f" ]]; then
      echo "Executable: yes"
    else
      echo "Executable: no (fix: chmod +x \"$f\")"
    fi
    first_line="$(head -n1 "$f" 2>/dev/null || echo "")"
    if [[ "$first_line" =~ ^'#!' ]]; then
      echo "Shebang: $first_line"
    else
      echo "Shebang: missing (suggest: #!/usr/bin/env bash)"
    fi
    refs="$(grep -RIn -- "$b" "$HYPR_DIR" 2>/dev/null || echo "")"
    if [[ -n "$refs" ]]; then
      echo "References in Hypr config:"
      echo "$refs" | sed 's/^/  /'
    else
      echo "References in Hypr config: none"
    fi
  done
  shopt -u nullglob
  set -e
}

# Install dotfiles: symlink .config/* dirs and zsh-home/* files into $HOME
install_dotfiles() {
  CONFIG_DIR="$HOME/.config"

  echo "Installing dotfiles from $DOTFILES_DIR"

  for dir in "$DOTFILES_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    config_name="$(basename "$dir")"

    # Skip meta-directories that don't belong in .config
    case "$config_name" in
      .git|zsh-home|hypr.bak) continue ;;
    esac

    dest="$CONFIG_DIR/$config_name"

    if [[ -L "$dest" ]]; then
      echo "  $config_name (already symlinked)"
    elif [[ -e "$dest" ]]; then
      echo "  $config_name (backing up existing to ${dest}.bak)"
      mv "$dest" "${dest}.bak"
      ln -sfn "$dir" "$dest"
      echo "  $config_name (symlinked)"
    else
      ln -sfn "$dir" "$dest"
      echo "  $config_name (symlinked)"
    fi
  done

  # zsh home files (.zshrc, .zshenv, .zprofile)
  ZSH_HOME_DIR="$DOTFILES_DIR/zsh-home"
  if [[ -d "$ZSH_HOME_DIR" ]]; then
    for f in "$ZSH_HOME_DIR"/.*; do
      [[ -f "$f" ]] || continue
      fname="$(basename "$f")"
      dest="$HOME/$fname"
      if [[ -L "$dest" ]]; then
        echo "  ~/$fname (already symlinked)"
      elif [[ -e "$dest" ]]; then
        echo "  ~/$fname (backing up to ${dest}.bak)"
        mv "$dest" "${dest}.bak"
        ln -sfn "$f" "$dest"
        echo "  ~/$fname (symlinked)"
      else
        ln -sfn "$f" "$dest"
        echo "  ~/$fname (symlinked)"
      fi
    done
  fi

  echo "Dotfiles installation complete!"
}

# Collect configs function (move configs from ~/.config to dotfiles)
collect_configs() {
  CONFIG_DIR="$HOME/.config"

  # Common configs that belong in dotfiles
  DOTFILE_CONFIGS=(
    "hypr"
    "waybar"
    "alacritty"
    "kitty"
    "foot"
    "ghostty"
    "rofi"
    "wofi"
    "tmux"
    "tmuxinator"
    "nvim"
    "vim"
    "git"
    "dunst"
    "mako"
    "fontconfig"
    "gtk-3.0"
    "gtk-4.0"
    "btop"
    "lazygit"
    "yazi"
    "nwg-look"
    "helix"
    "zellij"
  )

  echo "Collecting configs into dotfiles structure at $DOTFILES_DIR..."

  # Move existing configs to dotfiles
  for config_name in "${DOTFILE_CONFIGS[@]}"; do
    src_dir="$CONFIG_DIR/$config_name"
    target_path="$DOTFILES_DIR/$config_name"

    [[ -d "$src_dir" && ! -L "$src_dir" ]] || continue
    echo "Moving $src_dir -> $target_path"

    if [[ -d "$target_path" ]]; then
      echo "  Warning: $target_path already exists, merging..."
      if command -v rsync >/dev/null 2>&1; then
        rsync -av "$src_dir/" "$target_path/"
      else
        mkdir -p "$target_path"
        if [[ -n "$(ls -A "$src_dir" 2>/dev/null)" ]]; then
          cp -r "$src_dir"/* "$target_path/" 2>/dev/null || true
        fi
      fi
      rm -rf "$src_dir"
    else
      mv "$src_dir" "$target_path"
    fi
  done

  # Create symlinks for moved configs
  for config_name in "${DOTFILE_CONFIGS[@]}"; do
    src="$DOTFILES_DIR/$config_name"
    dest="$CONFIG_DIR/$config_name"
    if [[ -d "$src" ]]; then
      ln -sfn "$src" "$dest"
      echo "  Symlinked: $dest -> $src"
    fi
  done

  # Collect zsh home files
  ZSH_HOME_DIR="$DOTFILES_DIR/zsh-home"
  mkdir -p "$ZSH_HOME_DIR"
  for f in .zshrc .zshenv .zprofile; do
    src="$HOME/$f"
    dest="$ZSH_HOME_DIR/$f"
    if [[ -f "$src" && ! -L "$src" ]]; then
      mv "$src" "$dest"
      ln -sfn "$dest" "$src"
      echo "  Collected and symlinked: ~/$f"
    fi
  done

  echo "Config collection complete!"
  echo "  Source: $DOTFILES_DIR/"
  echo "  Configs collected: ${DOTFILE_CONFIGS[*]}"
}

# Interactive menu function
show_menu() {
  echo "=== Dotfiles Setup Menu ==="
  echo ""
  echo "Choose an option:"
  echo "1) Diagnose current setup (read-only)"
  echo "2) Install/update dotfiles symlinks"
  echo "3) Collect configs into dotfiles"
  echo "4) Diagnose Hypr config only"
  echo "5) Diagnose Hypr scripts only"
  echo "6) Exit"
  echo ""
  read -r -p "Enter your choice (1-6): " choice
  echo ""

  case "$choice" in
    1)
      echo "Running diagnosis..."
      diagnose
      echo
      diagnose_hypr
      ;;
    2)
      echo "Installing dotfiles symlinks..."
      install_dotfiles
      ;;
    3)
      echo "Collecting configs into dotfiles..."
      collect_configs
      ;;
    4)
      echo "Diagnosing Hypr config..."
      diagnose_hypr
      ;;
    5)
      echo "Diagnosing Hypr scripts..."
      diagnose_hypr_scripts
      ;;
    6)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      echo ""
      show_menu
      ;;
  esac
}

# Handle command line arguments
case "${1-}" in
  --diagnose|-d)
    diagnose
    echo
    diagnose_hypr
    ;;
  --diagnose-hypr|-H)
    diagnose_hypr
    ;;
  --diagnose-scripts|-s)
    diagnose_hypr_scripts
    ;;
  --install|-i)
    install_dotfiles
    ;;
  --collect|-c)
    collect_configs
    ;;
  --help|-h)
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --diagnose, -d         Diagnose current setup"
    echo "  --diagnose-hypr, -H    Diagnose Hypr config only"
    echo "  --diagnose-scripts, -s Diagnose Hypr scripts only"
    echo "  --install, -i          Install dotfiles symlinks"
    echo "  --collect, -c          Collect configs into dotfiles"
    echo "  --help, -h             Show this help"
    echo ""
    echo "Run without arguments for interactive menu"
    ;;
  "")
    show_menu
    ;;
  *)
    echo "Unknown option: $1"
    echo "Use --help for available options or run without arguments for interactive menu"
    exit 1
    ;;
esac
