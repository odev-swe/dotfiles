#!/bin/bash

echo "Homebrew section..."

if command -v brew &>/dev/null; then
    echo "Homebrew is installed"
else
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


echo "Homebrew formulae section..."

formulae=(git go nvm ripgrep gh nvim)

zshStuff=("zsh-completions" "zsh-autosuggestions" "zsh-syntax-highlighting" "powerlevel10k" "font-hack-nerd-font" "jq" "z")

for formulae in "${formulae[@]}"; do
  brew install "$formulae"
done

for zsh in "${zshStuff[@]}"; do
  brew install "$zsh"
done

echo "Clone dotfiles section..."

if [ -f ~/temp/ ]; then 
    rm -rf ~/temp/
    git clone https://github.com/odev-swe/dotfiles.git ~/temp/
fi

echo "Copy dotfiles to machines..."

cp ~/temp/.zshrc ~
cp ~/temp/.tmux.conf ~
cp -r ~/temp/.config/nvim/ ~/.config/nvim

echo "Tmux section..."

echo "Install Tmux Plugin Manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


echo "Restoration Completed!"