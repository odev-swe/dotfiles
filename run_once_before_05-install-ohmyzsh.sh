#!/usr/bin/env bash
set -euo pipefail

if [ -d "$HOME/.oh-my-zsh" ]; then
    exit 0
fi

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
