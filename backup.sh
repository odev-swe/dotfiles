echo "Backing up dotfiles..."

cp ~/.zshrc .
rsync -av --exclude="iterm2" --exclude="gh" --exclude="fish" --exclude="go" ~/.config/nvim .

echo "Backed up dotfiles!"
