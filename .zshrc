# zsh plugins
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /home/linuxbrew/.linuxbrew/opt/z/etc/profile.d/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" 
    fi
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /opt/homebrew/etc/profile.d/
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias c="clear"
alias lc="vim leetcode.nvim"
alias p="python3"
alias air="$HOME/go/bin/air" # Assuming `air` is installed in $HOME/go/bin
alias zshrc="vim ~/.zshrc"
alias zshrcs="source ~/.zshrc"
alias vim="nvim"
alias bl="brew list"
alias bu="brew update"
alias spotify="open /Applications/Spotify.app"
alias notion="open /Applications/Notion.app"
alias postman="open /Applications/Postman.app"
alias gcu="git config --global user.name"
alias gce="git config --global user.email"
alias gca="git config --list --show-origin"
alias tff="terraform fmt"
alias tfi="terraform init"
alias tfa="terraform apply"

# Export PATH
export PATH="/usr/local/bin:$HOME/flutter/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
