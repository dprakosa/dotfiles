#!/usr/bin/env bash
set -Eeuo pipefail

# Paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

has() {
  command -v "$1" >/dev/null 2>&1
}

# System packages
sudo apt-get update

sudo apt-get install -y \
  ca-certificates \
  curl \
  git \
  unzip \
  build-essential \
  pkg-config \
  cmake \
  software-properties-common \
  fontconfig \
  stow \
  zsh \
  fzf \
  tmux \
  tree \
  xclip \
  wl-clipboard \
  ripgrep \
  libclang-dev \
  python3 \
  python3-venv \
  python3-pip \
  shellcheck \
  ghostty \
  zoxide \
  lazygit

# Neovim
if grep -qi ubuntu /etc/os-release; then
  if ! grep -Rqs "neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
  fi
fi

sudo apt-get install -y neovim

# Rust
if ! has rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
    sh -s -- -y
fi

# shellcheck source=/dev/null
source "$HOME/.cargo/env"

rustup default stable
rustup component add rustfmt clippy rust-analyzer

# Tree-sitter CLI
if ! has tree-sitter; then
  cargo install tree-sitter-cli --locked
fi

# User binaries
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# Starship
if ! has starship; then
  curl -sS https://starship.rs/install.sh |
    sh -s -- -y -b "$HOME/.local/bin"
fi

# NVM + Node
NVM_VERSION="v0.40.7"
export NVM_DIR="$HOME/.nvm"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  curl -fsSL \
    "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" |
    PROFILE=/dev/null bash
fi

# Load NVM only for this bootstrap process.
# Interactive shells lazy-load it from .zshrc.
# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"

# Latest Node LTS
nvm install --lts
nvm alias default 'lts/*'
nvm use --silent default

# pnpm via Corepack
if ! has corepack; then
  npm install --global corepack
fi

corepack enable
corepack install --global pnpm@latest

# Nerd Font
font_dir="$HOME/.local/share/fonts"
font_regular="$font_dir/JetBrainsMonoNerdFontMono-Regular.ttf"

mkdir -p "$font_dir"

if [[ ! -f "$font_regular" ]]; then
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  curl -fLo "$tmp_dir/JetBrainsMono.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

  unzip -o "$tmp_dir/JetBrainsMono.zip" -d "$font_dir" \
    "JetBrainsMonoNerdFontMono-Regular.ttf" \
    "JetBrainsMonoNerdFontMono-Bold.ttf" \
    "JetBrainsMonoNerdFontMono-Italic.ttf" \
    "JetBrainsMonoNerdFontMono-BoldItalic.ttf"

  fc-cache -f
fi

# Tmux Plugin Manager
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ ! -f "$TPM_DIR/tpm" ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Dotfiles
cd "$DOTFILES_DIR"

stow \
  --restow \
  --no-folding \
  --target="$HOME" \
  --verbose \
  ghostty \
  nvim \
  tmux \
  zsh

# Install tmux plugins
"$TPM_DIR/bin/install_plugins"

# Default shell
zsh_path="$(command -v zsh)"
current_shell="$(getent passwd "$USER" | cut -d: -f7)"

if ! grep -qx "$zsh_path" /etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$current_shell" != "$zsh_path" ]]; then
  chsh -s "$zsh_path"
fi

# System configuration
sudo install -Dm644 \
  "$DOTFILES_DIR/system/10-lid-suspend.conf" \
  /etc/systemd/logind.conf.d/10-lid-suspend.conf

echo "Done. Restart your terminal."
