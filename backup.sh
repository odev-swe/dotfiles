cp ~/.zshrc .
rsync -av --exclude="iterm2" --exclude="gh" --exclude="fish" --exclude="iterm2" ~/.config/ ./.config/
