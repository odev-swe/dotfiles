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
  *)       echo "❌ Unsupported OS: $OS" && exit 1 ;;
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
  "yq"
  "jq"
  "gcc"
  "openfortivpn"
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

# --- JetBrains Mono Nerd Font ---
echo "🔤 Installing JetBrains Mono Nerd Font..."
if [ "$PLATFORM" = "macos" ]; then
  if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    brew install --cask font-jetbrains-mono-nerd-font
  else
    echo "✓ JetBrains Mono Nerd Font already installed"
  fi
elif [ "$PLATFORM" = "linux" ]; then
  FONT_DIR="$HOME/.local/share/fonts"
  if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    mkdir -p "$FONT_DIR"
    cd /tmp
    curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip -d "$FONT_DIR"
    rm JetBrainsMono.zip
    fc-cache -fv
    cd - > /dev/null
    echo "✓ JetBrains Mono Nerd Font installed"
  else
    echo "✓ JetBrains Mono Nerd Font already installed"
  fi
fi

echo ""
echo "✅ System bootstrap complete!"
echo "💡 Next steps:"
echo "   1. Restart your shell: exec zsh"
echo "   2. Verify tools: brew list"
echo "   3. Check dotfiles: chezmoi status"