#!/usr/bin/env bash
set -euo pipefail

# =====================================
#  Universal Dev Environment Bootstrap
#  Compatible with macOS and Linux
#  Author: Oscar (ODEV TECH Solutions)
# =====================================

DOTFILES_REPO="https://github.com/odev-swe/dotfiles.git"

echo "🚀 Starting system bootstrap..."

# --- Detect OS ---
OS="$(uname -s)"
case "$OS" in
  Linux*)  PLATFORM="linux" ;;
  Darwin*) PLATFORM="macos" ;;
  *)       echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

echo "🧠 Detected platform: $PLATFORM"

# --- Install Homebrew if missing ---
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Set up Homebrew in PATH
  if [ "$PLATFORM" = "linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    eval "$(/opt/homebrew/bin/brew shellenv)"
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
)

for pkg in "${BREW_PACKAGES[@]}"; do
  if ! command -v "$pkg" &>/dev/null; then
    echo "  → Installing $pkg..."
    brew install "$pkg"
  else
    echo "  ✓ $pkg already installed"
  fi
done

# --- Clone and apply dotfiles ---
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  echo "📦 Initializing chezmoi with dotfiles repo..."
  chezmoi init "$DOTFILES_REPO"
else
  echo "✓ Chezmoi already initialized"
fi

echo "⚙️  Applying chezmoi configuration..."
chezmoi apply -v

echo ""
echo "✅ System bootstrap complete!"
echo "💡 Next steps:"
echo "   1. Restart your shell: exec zsh"
echo "   2. Verify tools: brew list"
echo "   3. Check dotfiles: chezmoi status"
