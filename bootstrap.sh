#!/bin/bash

set -euo pipefail

# --- Variables ---
DOTFILES_REPO="https://github.com/odev-swe/dotfiles.git"

echo "🚀 Starting system bootstrap..."

# --- Detect OS ---
OS="$(uname -s)"
case "$OS" in
  Linux*)
    PLATFORM="linux"
    echo "🧠 Detected platform: $PLATFORM"
    ;;
  Darwin*)
    PLATFORM="macos"
    echo "🧠 Detected platform: $PLATFORM"
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# --- Install Git if missing ---
if ! command -v git &>/dev/null; then
  echo "🍃 Installing Git..."
  if [ "$PLATFORM" = "linux" ]; then
    sudo apt-get update
    sudo apt-get install -y git
  elif [ "$PLATFORM" = "macos" ]; then
    xcode-select --install || true
  fi
else
  echo "✓ Git already installed"
fi

# --- Install Homebrew if missing ---
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Set up Homebrew in PATH (covers Linux, Apple Silicon, and Intel Mac)
  if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"     # Apple Silicon
  fi
else
  echo "✓ Homebrew already installed"
fi

# --- Install essential tools via Brew ---
echo "📦 Installing essential tools..."
BREW_PACKAGES=(
  "chezmoi"
  "mise"
  "zoxide"
  "fzf"
  "yq"
  "jq"
  "openfortivpn"
  "unzip"
  "claude-code@latest"
  "awscli"
  "bitwarden-cli"
  "kubectl"
  "opentofu"
  "neovim"
)

for pkg in "${BREW_PACKAGES[@]}"; do
  if ! command -v "$pkg" &>/dev/null; then
    echo "  → Installing $pkg..."
    brew install "$pkg"
  else
    echo "  ✓ $pkg already installed"
  fi
done


# --- oh-my-zsh installation ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🌀 Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✓ oh-my-zsh already installed"
fi

# --- Powerlevel10k theme ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "⚡ Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "✓ Powerlevel10k already installed"
fi

# --- Install Nerd Font ---
FONT="JetBrainsMono Nerd Font"; \
if fc-list 2>/dev/null | grep -qi "$FONT"; then \
  echo "✓ $FONT already installed"; \
elif command -v brew >/dev/null 2>&1; then \
  brew list --cask font-jetbrains-mono-nerd-font &>/dev/null || brew install --cask font-jetbrains-mono-nerd-font; \
  echo "✓ $FONT installed via Homebrew"; \
else \
  DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"; \
  mkdir -p "$DIR" && \
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o /tmp/jbm.zip && \
  unzip -oq /tmp/jbm.zip -d "$DIR" && \
  rm -f /tmp/jbm.zip && \
  fc-cache -f >/dev/null && \
  echo "✓ $FONT installed manually"; \
fi

# --- Bitwarden login ---
bw login --check &>/dev/null || {
  echo "🔐 Please log in to Bitwarden:"
  bw login
}

export BW_SESSION="$(bw unlock --raw)"

# --- Clone and apply dotfiles ---
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  echo "📦 Initializing chezmoi with dotfiles repo..."
  chezmoi init "$DOTFILES_REPO"
else
  echo "✓ Chezmoi already initialized"
fi

echo "⚙️  Applying chezmoi configuration..."
chezmoi apply -v --force

# --- Install mise tools (requires ~/.config/mise/config.toml from chezmoi) ---
eval "$(mise activate bash)"
mise install

echo ""
echo "✅ System bootstrap complete!"
echo "💡 Next steps:"
echo "   1. Restart your shell: exec zsh"
echo "   2. Verify tools: brew list"
echo "   3. Check dotfiles: chezmoi status"
