#!/bin/bash

echo "Homebrew section..."

# Check the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$(uname)" == "Linux" ]]; then
    # Linux
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt-get install unzip
    sudo apt install zsh
    chsh -s $(which zsh)

    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
else
    echo "Unsupported operating system"
    exit 1
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is installed"
fi

echo "Homebrew formulae section..."

# List of Homebrew packages to install
formulae=(git go nvm ripgrep gh nvim)

# List of Zsh-related packages
zshStuff=("zsh-completions" "zsh-autosuggestions" "zsh-syntax-highlighting" "powerlevel10k" "font-ha
rm -rf ~/temp/ck-nerd-font" "jq" "z")

for formulae in "${formulae[@]}"; do
  brew install "$formulae"
done

for zsh in "${zshStuff[@]}"; do
  brew install "$zsh"
done

echo "Clone dotfiles section..."

# Clone dotfiles repository if it doesn't exist
if [ ! -d ~/temp/ ]; then 
    git clone https://github.com/odev-swe/dotfiles.git ~/temp/
else
    rm -rf ~/temp/
    git clone https://github.com/odev-swe/dotfiles.git ~/temp/
fi

echo "Copy dotfiles to machines..."

# Copy neovim and zsh configuration files
rm -rf ~/.config/nvim
cp -r ~/temp/nvim/ ~/.config/nvim
cp ~/temp/.zshrc ~
cp ~/temp/.tmux.conf ~

echo "Tmux section..."

echo "Install Tmux Plugin Manager..."
if [ ! -d ~/.tmux/ ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    rm -rf ~/.tmux/
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Nvm install node"
nvm install 20
nvm use 20

echo "Clean Up..."
rm -rf ~/temp/

source ~/.zshrc

echo "Restoration Completed!"
