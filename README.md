# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports **macOS** (Apple Silicon + Intel) and **Ubuntu/Debian** Linux.

Secrets (SSH keys, VPN config) are stored in Bitwarden and injected at apply time via chezmoi templates — no plaintext credentials in the repo.

---

## Prerequisites

- A Bitwarden account with the required vault items (see [Bitwarden Setup](#bitwarden-setup))
- `curl` and `bash` (present on all supported platforms)

---

## Quick Start

On a fresh machine, run the bootstrap script directly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/odev-swe/dotfiles/main/bootstrap.sh)
```

Or if you've already cloned the repo:

```bash
./bootstrap.sh
```

### What bootstrap does

1. Installs **Git** (via apt on Linux, Xcode CLI tools on macOS)
2. Installs **Homebrew** (handles Linux, Apple Silicon, and Intel Mac paths)
3. Installs core tools via Homebrew: `chezmoi`, `mise`, `zoxide`, `fzf`, `yq`, `jq`, `openfortivpn`, `unzip`, `bitwarden-cli`, `claude-code`
4. Prompts for **Bitwarden** login and unlocks the vault
5. Initialises and applies **chezmoi** (deploys all dotfiles, renders secret templates)
6. Runs **`mise install`** to install all tool versions from `config.toml`
7. Installs **oh-my-zsh**, **Powerlevel10k** theme, and **JetBrains Mono Nerd Font**

---

## Bitwarden Setup

Three vault items are required. Each must have its secret content stored in the **Notes** field:

| Item name      | Deployed to                        | Contents              |
|----------------|------------------------------------|-----------------------|
| `github-ssh`   | `~/.ssh/github`                    | GitHub private key    |
| `gitlab-ssh`   | `~/.ssh/gitlab`                    | GitLab private key    |
| `openfortivpn` | `~/.config/openfortivpn/config`    | openfortivpn config   |

To re-unlock the vault in an existing session:

```bash
bw_unlock   # sets BW_SESSION, then run: chezmoi apply
```

---

## Repository Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore                     # Files excluded from chezmoi apply
├── bootstrap.sh                       # One-time machine setup script
├── dot_zshrc                          # → ~/.zshrc
├── private_dot_config/
│   ├── mise/
│   │   └── config.toml                # → ~/.config/mise/config.toml
│   └── openfortivpn/
│       └── config.tmpl                # → ~/.config/openfortivpn/config (Bitwarden)
└── private_dot_ssh/
    ├── config                         # → ~/.ssh/config
    ├── private_github.tmpl            # → ~/.ssh/github (Bitwarden)
    └── private_gitlab.tmpl            # → ~/.ssh/gitlab (Bitwarden)
```

---

## Shell Environment

The `.zshrc` is built around:

- **[zinit](https://github.com/zdharma-continuum/zinit)** — plugin manager (auto-installs on first shell load)
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** — prompt theme with instant prompt enabled
- **[mise](https://mise.jdx.dev/)** — runtime version manager
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — replaces `cd` with frecency-based navigation
- **[fzf-tab](https://github.com/Aloxaf/fzf-tab)** — fuzzy completion with fzf

Loaded OMZ plugins: `git`, `sudo`, `aws`, `kubectl`, `kubectx`, `helm`, `fluxcd`, `command-not-found`

---

## Managed Tools (mise)

Defined in `private_dot_config/mise/config.toml`:

| Tool | Version |
|------|---------|
| go | 1.25.5 |
| gitversion | 5.12.0 |
| aws-cli, helm, helm-diff, kubectl, opentofu, flux2, k9s | latest |
| air, k6, golangci-lint, neovim, node, java, pnpm | latest |
| firebase, stripe, gomigrate, gitleaks, bitwarden | latest |

Run `mise install` after any changes to `config.toml`.

---

## Daily Usage

| Command | Description |
|---------|-------------|
| `ca` | `chezmoi apply --force --verbose && source ~/.zshrc` |
| `chezmoi diff` | Preview changes before applying |
| `chezmoi status` | Show which managed files have changed |
| `chezmoi edit ~/.zshrc` | Edit source file and apply |
| `bw_unlock` | Unlock Bitwarden vault (required for template re-renders) |
| `vpn` | Connect via openfortivpn |
| `full_update` | Update OS packages, Homebrew, mise tools, and chezmoi |

---

## License

MIT
