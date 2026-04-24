# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports **macOS** (Apple Silicon + Intel) and **Ubuntu/Debian** Linux.

Secrets (SSH keys, VPN, AWS config) are stored in Bitwarden and injected at apply time via chezmoi templates — no plaintext credentials in the repo.

---

## Prerequisites

- A Bitwarden account with the required vault items (see [Bitwarden Setup](#bitwarden-setup))
- `curl` and `bash`

---

## Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/odev-swe/dotfiles/main/bootstrap.sh)
```

`bootstrap.sh` is deliberately thin. It only installs what chezmoi itself needs to run:

1. Git
2. Homebrew
3. `chezmoi` + `bitwarden-cli`
4. Unlocks Bitwarden (`BW_SESSION`)
5. Runs `chezmoi init <repo>` → `chezmoi apply`

Everything else — brew packages, oh-my-zsh, powerlevel10k, JetBrains Mono Nerd Font, `mise install` — is handled inside chezmoi via `run_once_` and `run_onchange_` scripts. That means `chezmoi apply` on any machine, at any time, converges to the desired state.

---

## Bitwarden Setup

Four vault items are required, each with its secret in the **Notes** field:

| Item name      | Deployed to                        |
|----------------|------------------------------------|
| `github-ssh`   | `~/.ssh/github`                    |
| `gitlab-ssh`   | `~/.ssh/gitlab`                    |
| `openfortivpn` | `~/.config/openfortivpn/config` (Linux only) |
| `awsconfig`    | `~/.aws/config`                    |

To re-unlock in an existing session: `bw_unlock` (sets `BW_SESSION`), then `chezmoi apply`.

---

## Repository Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl              # First-run prompts (name, email, AWS profile/region)
├── .chezmoidata/
│   └── packages.yaml               # Brew formulae + casks per-OS
├── .chezmoitemplates/
│   └── bw-notes                    # Shared partial: Bitwarden notes lookup
├── .chezmoiignore.tmpl             # Per-OS ignore rules (e.g. openfortivpn on macOS)
├── bootstrap.sh                    # Thin bootstrap (git/brew/chezmoi/bw only)
├── dot_zshrc.tmpl                  # → ~/.zshrc (OS/arch-aware brew init, AWS from data)
├── dot_p10k.zsh                    # → ~/.p10k.zsh
├── dot_tmux.conf                   # → ~/.tmux.conf
├── dot_aws/
│   └── config.tmpl                 # → ~/.aws/config (from Bitwarden)
├── private_dot_config/
│   ├── mise/config.toml            # → ~/.config/mise/config.toml
│   └── openfortivpn/config.tmpl    # → ~/.config/openfortivpn/config (Linux-only, Bitwarden)
├── private_dot_ssh/
│   ├── config                      # → ~/.ssh/config
│   ├── private_github.tmpl         # → ~/.ssh/github (Bitwarden)
│   └── private_gitlab.tmpl         # → ~/.ssh/gitlab (Bitwarden)
├── run_once_before_05-install-ohmyzsh.sh
├── run_once_before_06-install-powerlevel10k.sh
├── run_once_after_30-install-nerd-font.sh.tmpl
├── run_onchange_before_10-install-brew-packages.sh.tmpl
└── run_onchange_after_20-mise-install.sh.tmpl
```

### Why run_once vs run_onchange?

- `run_once_*` — runs a single time per machine, tracked by script hash. Use for install steps that are idempotent and don't need re-running.
- `run_onchange_*` — reruns whenever the script contents change. The brew script templates in the package list, so editing `.chezmoidata/packages.yaml` causes the next `chezmoi apply` to install the new package automatically. The mise script embeds a hash of `config.toml`, so bumping a tool version triggers a fresh `mise install`.

---

## Shell Environment

`.zshrc` is built around:

- **[zinit](https://github.com/zdharma-continuum/zinit)** — plugin manager (auto-installs on first shell load)
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** — prompt theme with instant prompt
- **[mise](https://mise.jdx.dev/)** — runtime version manager
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — `cd` replacement with frecency
- **[fzf-tab](https://github.com/Aloxaf/fzf-tab)** — fuzzy completion

Loaded OMZ plugins: `git`, `sudo`, `aws`, `kubectl`, `kubectx`, `helm`, `fluxcd`, `command-not-found`.

---

## Managed Tools (mise)

Defined in `private_dot_config/mise/config.toml`. Run `mise install` after changes — or just `chezmoi apply`, which will detect the change and rerun `mise install` automatically.

---

## Daily Usage

| Command | Description |
|---------|-------------|
| `ca` | Unlock Bitwarden + `chezmoi apply --force --verbose` + reload shell |
| `chezmoi diff` | Preview pending changes |
| `chezmoi status` | Show which managed files have changed |
| `chezmoi edit ~/.zshrc` | Edit source and apply |
| `bw_unlock` | Re-export `BW_SESSION` in the current shell |
| `vpn` | Connect via openfortivpn (Linux only) |
| `full_update` | Update OS packages, Homebrew, mise tools, chezmoi |
| `claude-sync` | Re-capture `~/.claude/*` into the source repo |

---

## Adding a new package

Edit `.chezmoidata/packages.yaml`, then run `chezmoi apply`. The run_onchange brew script hashes the file, detects the change, and installs the delta.

## License

MIT
