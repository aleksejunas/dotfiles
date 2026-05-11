# Idempotent PATH helper
path_add() { case ":$PATH:" in (*":$1:"*) ;; (*) PATH="$1:$PATH";; esac }

# Tools you actually need everywhere
path_add "$HOME/.local/bin"
path_add "$HOME/.cargo/bin"
path_add "$HOME/.dotnet/tools"
path_add "$HOME/.pnpm-global/bin"
path_add "$HOME/.bun/bin"
path_add "$HOME/Scripts"

export PATH
export QT_QPA_PLATFORMTHEME=qt5ct
