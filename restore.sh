#!/bin/bash

# Define colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Function for colorful output
info() { echo -e "${BLUE}INFO:${RESET} $1"; }
success() { echo -e "${GREEN}SUCCESS:${RESET} $1"; }
warning() { echo -e "${YELLOW}WARNING:${RESET} $1"; }
error() { echo -e "${RED}ERROR:${RESET} $1"; }

# Function to install Homebrew if not present
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        warning "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && success "Homebrew installed successfully!"
    else
        info "Homebrew is already installed. Updating Homebrew..."
        brew update && success "Homebrew updated successfully!"
    fi
}

# Function to install Homebrew packages
install_brew_packages() {
    local packages=("$@")
    info "Installing Homebrew packages..."
    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            success "$package is already installed. Skipping..."
        else
            info "Installing $package..."
            brew install "$package" && success "$package installed successfully!"
        fi
    done
}

# Function to install Homebrew cask applications
install_cask_packages() {
    local cask_packages=("$@")
    info "Installing Homebrew cask applications..."
    for package in "${cask_packages[@]}"; do
        if brew list --cask "$package" &>/dev/null; then
            success "$package is already installed. Skipping..."
        else
            info "Installing $package..."
            brew install --cask "$package" && success "$package installed successfully!"
        fi
    done
}

# Function to configure GitHub CLI authentication
configure_github_auth() {
    info "Checking GitHub authentication..."
    if ! gh auth status &>/dev/null; then
        warning "GitHub authentication is not set. Setting up GitHub authentication..."
        gh auth login && success "GitHub authentication set up successfully!"
    else
        success "GitHub authentication is already set. Skipping..."
    fi
}

# Function to stow dotfiles
stow_dotfiles() {
    local stow_dir="/Users/odev/Documents/github/dotfiles"
    local files=("$@")
    info "Restoring dotfiles..."
    for file in "${files[@]}"; do
        info "Stowing $file..."
        if stow --target="$HOME" --dir="$stow_dir" "$file" &>/dev/null; then
            success "Successfully stowed $file!"
        else
            error "Failed to stow $file. Check the file path and permissions."
        fi
    done
}

# Main Script Execution
main() {
    # Install Homebrew and update it
    install_homebrew

    # Define packages
    brew_packages=("git" "nvm" "gh" "stow")
    cask_packages=("spotify" "visual-studio-code" "google-chrome")
    stow_files=("zsh")

    # Install packages
    install_brew_packages "${brew_packages[@]}"
    install_cask_packages "${cask_packages[@]}"

    # Configure GitHub CLI
    configure_github_auth

    # Stow dotfiles
    stow_dotfiles "${stow_files[@]}"

    # Source zshrc
    if [ -f ~/.zshrc ]; then
        info "Sourcing ~/.zshrc..."
        source ~/.zshrc && success "Shell configuration loaded successfully!"
    else
        warning "No ~/.zshrc found to source."
    fi

    success "Setup completed successfully!"
}

# Run main function
main
exit 0
