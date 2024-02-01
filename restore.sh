#!/bin/bash
# inspired by PScoriae
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# List of common developer tools
tools=("nvm" "neovim" "hugo" "gh" "hashicorp/tap/terraform" "git" "go" "ripgrep")

# List of zsh stuff
zshStuff=("zsh-completions" "zsh-autosuggestions" "zsh-syntax-highlighting" "powerlevel10k" "font-hack-nerd-font" "jq")

# List of casks
casks=("github" "iterm2" "postman" "tailscale" "visual-studio-code" "sf-symbols")

# List of formulae
formulae=("homebrew/cask-fonts" "hashicorp/tap")

# Install formulae
for formulae in "${formulae[@]}"; do
  brew tap "$formulae"
done


# Install common developer tools
for tool in "${tools[@]}"; do
  brew install "$tool"
done

# Install zsh stuff
for zsh in "${zshStuff[@]}"; do
  brew install "$zsh"
done

# Install casks
for cask in "${casks[@]}"; do
  brew install --cask "$cask"
done

echo "Restoration Completed!"
