# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
#plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"

# Load and initialise completion system
autoload -Uz compinit
compinit

PROMPT_NEEDS_NEWLINE=false

precmd() {
  if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
    echo
  fi
  PROMPT_NEEDS_NEWLINE=true
}

clear() {
  PROMPT_NEEDS_NEWLINE=false
  command clear
}


alias ls="exa --icons"

eval "$(starship init zsh)"

# bun completions
[ -s "/home/gaurab/.bun/_bun" ] && source "/home/gaurab/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
