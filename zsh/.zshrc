HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/gorob/.zshrc'

autoload -Uz compinit
compinit

eval "$(starship init zsh)"

export PATH="${PATH}:${HOME}/.local/bin/"
alias build='~/scripts/build'
alias ls="exa"
path+=('/home/gorob/.cargo/bin')
path+=('/home/gorob/scripts')
export PATH
