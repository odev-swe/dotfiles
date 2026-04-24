#!/usr/bin/env bash
# Minimal bootstrap. Installs only what chezmoi itself needs,
# then hands off to `chezmoi init` which runs all run_once_ / run_onchange_
# scripts (brew packages, oh-my-zsh, p10k, nerd font, mise install).

set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/odev-swe/dotfiles.git}"

echo "🚀 Bootstrapping dotfiles host..."

# --- Detect OS -------------------------------------------------------------
case "$(uname -s)" in
  Linux)  PLATFORM=linux  ;;
  Darwin) PLATFORM=darwin ;;
  *) echo "❌ Unsupported OS: $(uname -s)"; exit 1 ;;
esac
echo "🧠 Platform: $PLATFORM"

# --- Git -------------------------------------------------------------------
if ! command -v git >/dev/null; then
  if [ "$PLATFORM" = linux ]; then
    sudo apt-get update && sudo apt-get install -y git
  else
    xcode-select --install || true
  fi
fi

# --- Homebrew --------------------------------------------------------------
if ! command -v brew >/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for candidate in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
  [ -x "$candidate" ] && eval "$("$candidate" shellenv)" && break
done

# --- chezmoi + bitwarden CLI ----------------------------------------------
for pkg in chezmoi bitwarden-cli; do
  command -v "${pkg%-cli}" >/dev/null || brew install "$pkg"
done

# --- Bitwarden session (required for template rendering) -------------------
bw login --check >/dev/null 2>&1 || bw login
export BW_SESSION="$(bw unlock --raw)"

# --- Hand off to chezmoi ---------------------------------------------------
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  chezmoi init "$DOTFILES_REPO"
fi
chezmoi apply -v --force

echo ""
echo "✅ Bootstrap complete. Restart your shell: exec zsh"
