# ------------------------------
# COMPLETION
# ------------------------------
autoload -Uz compinit
compinit -d ~/.zcompdump
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{A-Z}={a-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'

# ------------------------------
# HISTORY
# ------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ------------------------------
# OPTIONS
# ------------------------------
setopt AUTO_CD

# ------------------------------
# PLUGINS
# ------------------------------

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ------------------------------
# KEYBINDINGS
# ------------------------------
bindkey -e
bindkey '^[[C'  autosuggest-partial-accept   # høyrepil aksepterer forslag
bindkey '^[[C'  forward-char     # høyrepil aksepterer forslag
bindkey '^[[3~' delete-char      # Delete
bindkey '^[[H'  beginning-of-line # Home
bindkey '^[[F'  end-of-line       # End

# zsh-navigation-tools
autoload -Uz znt-history-widget
zle -N znt-history-widget
bindkey '^R' znt-history-widget

# ------------------------------
# EDITOR
# ------------------------------
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ------------------------------
# PATH
# ------------------------------
path_add() { case ":$PATH:" in (*":$1:"*) ;; (*) PATH="$1:$PATH";; esac }

path_add "$HOME/.local/bin"
path_add "$HOME/.local/bin/scripts"
path_add "$HOME/.cargo/bin"
path_add "$HOME/.dotnet/tools"
path_add "$HOME/.pnpm-global/bin"
path_add "$HOME/.bun/bin"
path_add "$HOME/Scripts"
path_add "$HOME/go/bin"
path_add "$HOME/bin"

export PATH

# ------------------------------
# ENVIRONMENT
# ------------------------------
export GHOSTHOST_IP="100.118.165.125"
export QT_SCALE_FACTOR=2

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export PNPM_HOME="/home/rolf/.local/share/pnpm"
path_add "$PNPM_HOME"

# NVM — lazy load for å unngå treig oppstart
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  [[ -s /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh
  nvm "$@"
}

# pyenv — lazy load
export PYENV_ROOT="$HOME/.pyenv"
path_add "$PYENV_ROOT/bin"
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
path_add "$HOME/.bun/bin"

# FZF
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]]    && source /usr/share/fzf/completion.zsh

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# ------------------------------
# ALIASES
# ------------------------------

# ZSH NAVIGATION

## EZA
alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --icons --group-directories-first --git"
alias lt="eza --tree --icons --level=2"

# alias z="zoxide"

# Pacman
alias pu="sudo pacman -Syu"
alias pi="sudo pacman -S"
alias pr="sudo pacman -Rsc"

# systemd
alias sctlu="systemctl --user"
alias sctl="systemctl"

# ssh
alias mobil="ssh -p 8022 192.168.1.35"

# Yay
alias yu="yay -Syu"
alias yi="yay -S"
alias ys="yay -Ss"
alias yr="yay -Rsc"

# JottaCli
alias jc="jotta-cli"
alias jcs="jotta-cli status"
alias jco="jotta-cli observe"
alias jcl="jotta-cli list"
alias jch="jotta-cli help"

# Dotfiles
alias ehl="nvim ~/dotfiles/hypr/hyprland.conf"
alias ewb="nvim ~/dotfiles/waybar/config.jsonc"
alias ezsh="nvim ~/.zshrc"
alias szsh="source ~/.zshrc"

# Scripts

alias fwzone="sudo bash $HOME/.local/bin/scripts/fwzone"
alias janitor="sh ~/Scripts/janitor.sh"
alias imgsq="sh bash ~/.local/bin/scripts/img-square.sh"
 
# Apps
alias n="nvim"
alias sf="spf"
alias lg="lazygit"
alias wb="waybar &"
alias rw="killall waybar && waybar &"
alias ghce="gh copilot explain"

# Wayland
alias code="code --ozone-platform=wayland"
alias VirtualBox="export QT_QPA_PLATFORMTHEME=gtk3 VirtualBox"

# Diverse
alias bats="bat --style=plain"
alias npm='pnpm'
alias pva="source .venv/bin/activate"
alias tmxstart="tmuxinator start"
alias tmxstop="tmuxinator stop"

# Geary
alias geary-new='XDG_CONFIG_HOME=~/.config/geary-new geary'
alias geary="geary-new"

# ------------------------------
# PROMPT (Starship)
# ------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
