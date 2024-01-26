cp ~/.zshrc .
cp ~/.wakatime.cfg .
rsync -av --exclude="iterm2" --exclude="gh" ~/.config/ ./.config/
