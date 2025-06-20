#!/bin/bash

# Install chezmoi
if ! command -v chezmoi >/dev/null; then
    echo "Installing Chezmoi"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:odev-swe/dotfiles.git
fi

exit 0