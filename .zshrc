ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

bindkey -e

autoload -Uz compinit
compinit

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

setopt histignorealldups appendhistory sharehistory hist_ignore_space

HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

alias ls='ls --color=auto'
alias vim='nvim'

export PATH="$PATH:/opt/nvim/"

eval "$(starship init zsh)"
