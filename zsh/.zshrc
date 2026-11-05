# paths
typeset -U PATH path

export PNPM_HOME="$HOME/.local/share/pnpm"

path=(
    "$PNPM_HOME"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    $path
    /usr/local/go/bin
)

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# keybindings
bindkey -e
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# completions
autoload -Uz compinit select-word-style
compinit -C
select-word-style bash

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# history
setopt histignorealldups appendhistory sharehistory hist_ignore_space interactive_comments

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# aliases
alias ls='ls -lh --color=auto'
alias vim='nvim'
alias copy='wl-copy'

# nvm lazy-load
# export NVM_DIR="$HOME/.nvm"
# if [ -s "$NVM_DIR/nvm.sh" ]; then
#     source "$NVM_DIR/nvm.sh"
# fi
#
# if [ -s "$NVM_DIR/bash_completion" ]; then
#     source "$NVM_DIR/bash_completion"
# fi
eval "$(fnm env --use-on-cd --shell zsh)"

# node_commands=(nvm node npm npx yarn pnpm corepack codex)
#
# load_nvm() {
#     for cmd in "${node_commands[@]}"; do
#         unalias "$cmd" 2>/dev/null
#     done
#
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
#     "$@"
# }
#
# for cmd in "${node_commands[@]}"; do
#     alias "$cmd=load_nvm $cmd"
# done
#
# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# editor
export EDITOR=nvim
export VISUAL=nvim

# prompt
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# local config
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# bun completions
[ -s "/home/ran/.bun/_bun" ] && source "/home/ran/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
