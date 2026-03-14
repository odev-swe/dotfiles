# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository that manages shell config, SSH keys, tool versions, and VPN config across machines. Secrets are stored in Bitwarden and pulled at apply time via Go templates.

## Key Commands

```bash
# Apply dotfiles to home directory
chezmoi apply

# Force apply and reload shell (also available as alias `ca` once zshrc is applied)
chezmoi apply --force --verbose

# Preview changes before applying
chezmoi diff

# Check status of managed files
chezmoi status

# Edit a source file and apply in one step
chezmoi edit ~/.zshrc

# Bootstrap a new machine from scratch
./bootstrap.sh
```

### Bitwarden (required for templates)

```bash
# Unlock vault and export session token before running chezmoi apply
export BW_SESSION="$(bw unlock --raw)"
chezmoi apply
```

## File Naming Conventions

chezmoi uses a specific naming scheme in the source directory:

| Source name | Target path | Notes |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | `dot_` prefix becomes `.` |
| `private_dot_ssh/` | `~/.ssh/` | `private_` sets 0600 permissions |
| `*.tmpl` | (same, without `.tmpl`) | Processed as Go template |

## Architecture

### Templates and Secrets

The three `.tmpl` files fetch secrets from Bitwarden at apply time:
- `private_dot_ssh/private_github.tmpl` → `~/.ssh/github` — reads `notes` from Bitwarden item `github-ssh`
- `private_dot_ssh/private_gitlab.tmpl` → `~/.ssh/gitlab` — reads `notes` from Bitwarden item `gitlab-ssh`
- `private_dot_config/openfortivpn/config.tmpl` → `~/.config/openfortivpn/config` — reads `notes` from Bitwarden item `openfortivpn`

Template pattern used throughout:
```
{{- $jsonStr := (output "bash" "-c" "bw get item '<item-name>'") -}}
{{- $json := $jsonStr | fromJson -}}
{{ $json.notes }}
```

### ZSH Configuration (`dot_zshrc`)

Uses **zinit** as the plugin manager (auto-installs on first shell load). Plugins loaded:
- `zsh-syntax-highlighting`, `zsh-completions`, `zsh-autosuggestions`, `fzf-tab`
- OMZ snippets: git, sudo, archlinux, aws, kubectl, kubectx, helm, fluxcd, command-not-found

Shell integrations initialized: **Powerlevel10k** (theme), **mise** (`eval "$(mise activate zsh)"`), **zoxide** (replaces `cd`).

### Tool Management (`private_dot_config/mise/config.toml`)

mise manages all dev tool versions. Notable pinned versions: `gitversion = "5.12.0"`, `go = "1.25.5"`. All other tools track `latest`. Run `mise install` after applying to install/update tools.

### Bootstrap Script (`bootstrap.sh`)

Idempotent setup for a new machine. Order of operations:
1. Installs Git (apt/xcode-select)
2. Installs Homebrew
3. Installs Brew packages: chezmoi, mise, zoxide, fzf, yq, jq, openfortivpn, unzip
4. Activates mise and runs `mise install`
5. Logs into Bitwarden and exports `BW_SESSION`
6. Initializes chezmoi from the dotfiles repo and runs `chezmoi apply`
7. Installs oh-my-zsh (unattended)
8. Clones Powerlevel10k theme
9. Installs JetBrains Mono Nerd Font (cask on macOS, manual download on Linux)
