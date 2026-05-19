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
  xclip \
  wl-clipboard \
  ripgrep \
  libclang-dev

# Neovim
if grep -qi ubuntu /etc/os-release; then
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  sudo apt-get update
fi

sudo apt-get install -y neovim

# Rust
if ! has rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

source "$HOME/.cargo/env"

rustup default stable
rustup component add rustfmt clippy rust-analyzer

# Tree-sitter CLI
if ! has tree-sitter; then
  cargo install tree-sitter-cli --locked
fi

# Starship
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if ! has starship; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

# Font
font_dir="$HOME/.local/share/fonts"
tmp_dir="$(mktemp -d)"

mkdir -p "$font_dir"

curl -fLo "$tmp_dir/JetBrainsMono.zip" \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

unzip -o "$tmp_dir/JetBrainsMono.zip" -d "$font_dir" \
  "JetBrainsMonoNerdFontMono-Regular.ttf" \
  "JetBrainsMonoNerdFontMono-Bold.ttf" \
  "JetBrainsMonoNerdFontMono-Italic.ttf" \
  "JetBrainsMonoNerdFontMono-BoldItalic.ttf"

fc-cache -fv "$font_dir"
rm -rf "$tmp_dir"

# Dotfiles
cd "$DOTFILES_DIR"

stow --no-folding --target="$HOME" --verbose --simulate .
stow --no-folding --target="$HOME" --verbose .

# Default shell
zsh_path="$(command -v zsh)"

if ! grep -qx "$zsh_path" /etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

chsh -s "$zsh_path"

echo "Done. Restart your terminal."
