#!/usr/bin/env bash
set -euo pipefail

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

# Allow running only diagnostics without changing files.
if [[ "${1-}" == "--diagnose" || "${1-}" == "-d" ]]; then
  diagnose
  echo
  diagnose_hypr
  exit 0
elif [[ "${1-}" == "--diagnose-hypr" || "${1-}" == "-H" ]]; then
  diagnose_hypr
  exit 0
elif [[ "${1-}" == "--diagnose-scripts" || "${1-}" == "-s" ]]; then
  diagnose_hypr_scripts
  exit 0
elif [[ "${1-}" == "--dotfiles" ]]; then
  # Dotfiles-first approach: ~/dotfiles/ as source of truth
  DOTFILES_DIR="$HOME/dotfiles"
  WAYBAR_DIR="$HOME/.config/waybar"
  HYPR_DIR="$HOME/.config/hypr"
  
  mkdir -p "$DOTFILES_DIR"/{hypr,waybar}
  
  # Move existing configs to dotfiles
  for src_dir in "$HYPR_DIR" "$WAYBAR_DIR"; do
    [[ -d "$src_dir" && ! -L "$src_dir" ]] || continue
    target_name="$(basename "$src_dir")"
    target_path="$DOTFILES_DIR/$target_name"
    echo "Moving $src_dir -> $target_path"
    
    if [[ -d "$target_path" ]]; then
      echo "  Warning: $target_path already exists, merging..."
      # Use rsync for safer merging, fall back to cp if rsync unavailable
      if command -v rsync >/dev/null 2>&1; then
        rsync -av "$src_dir/" "$target_path/"
      else
        # Ensure target directory structure exists
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
  
  # Create symlinks with validation
  for config_name in hypr waybar; do
    src="$DOTFILES_DIR/$config_name"
    dest="$HOME/.config/$config_name"
    if [[ -d "$src" ]]; then
      ln -sfn "$src" "$dest"
      echo "  Symlinked: $dest -> $src"
    else
      echo "  Warning: $src doesn't exist, skipping symlink"
    fi
  done
  
  echo "Dotfiles setup complete:"
  echo "  Source: $DOTFILES_DIR/"
  echo "  Initialize Git: cd ~/dotfiles && git init"
  exit 0
fi

# Git-first approach: make your Git hypr repo the source of truth
WAYBAR_DIR="$HOME/.config/waybar"
HYPR_DIR="$HOME/.config/hypr"
HYPR_WAYBAR_DIR="$HYPR_DIR/waybar"

# Ensure hypr directory exists and is a real directory (not symlink)
if [[ ! -d "$HYPR_DIR" ]]; then
  echo "Error: $HYPR_DIR doesn't exist. Please ensure Hyprland is properly installed."
  exit 1
fi

if [[ -L "$HYPR_DIR" ]]; then
  echo "Error: $HYPR_DIR is a symlink. This script expects it to be your Git repo."
  exit 1
fi

# Ensure hypr/waybar exists in your Git repo
mkdir -p "$HYPR_WAYBAR_DIR"

# If ~/.config/waybar exists as a real directory, move its contents to Git repo
if [[ -d "$WAYBAR_DIR" && ! -L "$WAYBAR_DIR" ]]; then
  echo "Moving existing ~/.config/waybar contents to Git repo..."
  # Check if waybar directory has any files
  if [[ -n "$(ls -A "$WAYBAR_DIR" 2>/dev/null)" ]]; then
    for item in "$WAYBAR_DIR"/*; do
      [[ -e "$item" ]] || continue
      item_name="$(basename "$item")"
      target="$HYPR_WAYBAR_DIR/$item_name"
      if [[ ! -e "$target" ]]; then
        mv "$item" "$target"
        echo "  Moved: $item_name"
      else
        echo "  Skipping $item_name - already exists in Git repo"
      fi
    done
  fi
  rmdir "$WAYBAR_DIR" 2>/dev/null || rm -rf "$WAYBAR_DIR"
fi

# Create symlink: ~/.config/waybar -> ~/.config/hypr/waybar
if ! ln -sfn "$HYPR_WAYBAR_DIR" "$WAYBAR_DIR"; then
  echo "Error: Failed to create symlink $WAYBAR_DIR -> $HYPR_WAYBAR_DIR"
  exit 1
fi

echo "Git-first setup complete:"
echo "  Source of truth: $HYPR_WAYBAR_DIR (in your Git repo)"
echo "  Symlink created: $WAYBAR_DIR -> $HYPR_WAYBAR_DIR"
echo "  Waybar will find configs at the symlinked path"
echo "  All changes are now version controlled in your hypr repo"
echo ""
echo "Restart Waybar to apply: killall waybar"
