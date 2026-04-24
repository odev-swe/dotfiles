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
# Reuse a cached session token if one is still valid; otherwise prompt once
# and cache to $XDG_STATE_HOME/bw/session (mode 0600) for future shells + applies.
BW_CACHE="${XDG_STATE_HOME:-$HOME/.local/state}/bw/session"

bw_session_valid() {
  [ -n "${1:-}" ] || return 1
  BW_SESSION="$1" bw status 2>/dev/null | grep -q '"status":"unlocked"'
}

bw login --check >/dev/null 2>&1 || bw login

if ! bw_session_valid "${BW_SESSION:-}"; then
  if [ -r "$BW_CACHE" ] && bw_session_valid "$(cat "$BW_CACHE")"; then
    export BW_SESSION="$(cat "$BW_CACHE")"
  else
    export BW_SESSION="$(bw unlock --raw)"
    mkdir -p "$(dirname "$BW_CACHE")"
    ( umask 077 && printf '%s' "$BW_SESSION" > "$BW_CACHE" )
  fi
fi

# --- Hand off to chezmoi ---------------------------------------------------
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  chezmoi init "$DOTFILES_REPO"
fi
chezmoi apply -v --force

echo ""
echo "✅ Bootstrap complete. Restart your shell: exec zsh"
