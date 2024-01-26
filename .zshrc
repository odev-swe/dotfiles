# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" 
fi


# zsh plugins
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/etc/profile.d/z.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh. [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# key alias

# daily
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias c="clear"

# python
alias p="python"

# zshrc
alias zshrc="vim ~/.zshrc"
alias zshrcs="source ~/.zshrc"
alias vim="nvim"

# brew
alias bl="brew list"
alias bu="brew update"

# application
alias spotify="open /Applications/Spotify.app"
alias notion="open /Applications/Notion.app"

# git
alias gcu="git config --global user.name"
alias gce="git config --global user.email"

# terraform
alias tff="terraform fmt"
alias tfi="terraform init"
alias tfa="terraform apply"

export PATH="/usr/local/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm 
export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
