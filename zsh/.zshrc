# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gorob/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"

#export PATH=$PATH:/home/gorob/.spicetify
source /usr/share/nvm/init-nvm.sh
# (cat ~/.cache/wal/sequences &)
# Import the colors.
. "${HOME}/.cache/wal/colors.sh"

# Create the alias.
alias dmen='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'
export PATH="${PATH}:${HOME}/.local/bin/"
alias build='~/scripts/build'
alias ls="exa"
path+=('/home/gorob/.cargo/bin')
export PATH
