# zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# completions
autoload -Uz compinit select-word-style
compinit -C
select-word-style bash
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# history
setopt histignorealldups appendhistory sharehistory hist_ignore_space
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# aliases
alias ls='ls -lh --color=auto'
alias vim='nvim'
alias copy='xclip -selection clipboard'

export PATH="$HOME/.local/bin:$PATH"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# go
export PATH=$PATH:/usr/local/go/bin

# nvm lazy-load
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export NVM_DIR="$HOME/.nvm"
node_commands=(nvm node npm npx yarn pnpm corepack codex)
load_nvm() {
	for cmd in "${node_commands[@]}"; do
		unalias "$cmd" 2>/dev/null
	done
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
	"$@"
}
for cmd in "${node_commands[@]}"; do
	alias "$cmd=load_nvm $cmd"
done

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"


# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

export EDITOR=nvim
export VISUAL=nvim

# starship
eval "$(starship init zsh)"

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


