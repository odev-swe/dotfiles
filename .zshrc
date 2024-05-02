# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export PATH="/usr/local/bin:$HOME/flutter/bin:$PATH"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /home/linuxbrew/.linuxbrew/opt/z/etc/profile.d/z.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /opt/homebrew/etc/profile.d/z.sh
fi


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
