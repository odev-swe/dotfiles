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
  Linux*)  
    PLATFORM="linux"
    # Detect if Arch Linux
    if [ -f /etc/arch-release ]; then
      DISTRO="arch"
      echo "🧠 Detected platform: Arch Linux"
    else
      DISTRO="other"
      echo "🧠 Detected platform: $PLATFORM"
    fi
    ;;
  Darwin*) 
    PLATFORM="macos"
    DISTRO="macos"
    echo "🧠 Detected platform: $PLATFORM"
    ;;
  *)       echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

# --- Install package manager and tools ---
if [ "$DISTRO" = "arch" ]; then
  echo "📦 Installing essential tools via pacman..."
  
  # Update package database
  sudo pacman -Sy
  
  PACMAN_PACKAGES=(
    "chezmoi"
    "fzf"
    "jq"
  )
  
  # Install packages that are available in official repos
  for pkg in "${PACMAN_PACKAGES[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      echo "  → Installing $pkg..."
      sudo pacman -S --noconfirm "$pkg"
    else
      echo "  ✓ $pkg already installed"
    fi
  done
  
  # Install AUR packages (mise, zoxide, yq)
  if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    echo "⚠️  AUR helper not found. Installing yay..."
    cd /tmp
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
  fi
  
  AUR_PACKAGES=(
    "mise"
    "zoxide"
    "yq"
  )
  
  AUR_HELPER="yay"
  if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
  fi
  
  for pkg in "${AUR_PACKAGES[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
      echo "  → Installing $pkg from AUR..."
      $AUR_HELPER -S --noconfirm "$pkg"
    else
      echo "  ✓ $pkg already installed"
    fi
  done
  
else
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
  )

  for pkg in "${BREW_PACKAGES[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
      echo "  → Installing $pkg..."
      brew install "$pkg"
    else
      echo "  ✓ $pkg already installed"
    fi
  done
fi

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
