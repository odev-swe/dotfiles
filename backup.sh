echo "Backing up dotfiles..."

cp ~/.zshrc .
rsync -av --exclude="iterm2" --exclude="gh" --exclude="fish" ~/.config/ .

echo "Backed up dotfiles!"
