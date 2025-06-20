#!/bin/bash

# only run for arch
if [[ "$(uname -s)" != "Linux" ]] || ! grep -q "Arch" /etc/os-release; then
    echo "This script is intended for Arch Linux only."
    # download for yay
    if ! command -v yay &> /dev/null; then
        echo "yay is not installed. Please install yay first."
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        exit 1
    fi
fi

# Install chezmoi
if ! command -v chezmoi >/dev/null; then
    echo "Installing Chezmoi"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/odev-swe/dotfiles.git
fi

exit 0


