HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/gorob/.zshrc'

autoload -Uz compinit
compinit

eval "$(starship init zsh)"

export PATH="${PATH}:${HOME}/.local/bin/"
alias ls="exa --icons"
path+=('/home/gaurab/.cargo/bin')
path+=('/home/gaurab/scripts')
path+=('/home/gaurab/.spicetify')
export PATH
