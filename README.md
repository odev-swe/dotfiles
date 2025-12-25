# 🏠 dotfiles

> *"It works on my machine!"* — Famous last words before discovering your dotfiles are completely broken

<div align="center">

```
   ___      _    __ _ _           
  |   \ ___| |_ / _(_) |___ ___   
  | |) / _ \  _|  _| | / -_|_-<   
  |___/\___/\__|_| |_|_\___/__/   
                                  
```

</div>

## 📋 What's This?

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) because I got tired of manually copying config files between machines like a caveman.

![It's not much but it's honest work](https://i.imgflip.com/2/2h6pgx.jpg)

## ✨ Features

- 🔐 **Bitwarden integration** - Because storing SSH keys in plaintext is *so* 2010
- 🛠️ **mise for tool management** - One config to rule them all
- 🐚 **ZSH configuration** - With aliases that definitely make sense to future me
- 📦 **Bootstrap script** - From zero to hero in one command (allegedly)

## 🚀 Installation

```bash
# Clone this bad boy
chezmoi init https://github.com/yourusername/dotfiles.git

# Apply the configs (what could go wrong?)
chezmoi apply

# Run bootstrap if you're feeling brave
./bootstrap.sh
```

> ⚠️ **Warning**: This will overwrite your existing configs. Make backups unless you like living dangerously.

![This is fine](https://i.imgflip.com/2/2fqdr7.jpg)

## 🔑 Bitwarden Setup

The SSH keys are stored in Bitwarden because I learned the hard way that Git repos and private keys don't mix well.

```bash
# Unlock Bitwarden
bw-unlock

# Sync your vault
bw sync

# Now chezmoi can pull your secrets
chezmoi apply
```

## 📁 Structure

```
~/.local/share/chezmoi/
├── dot_zshrc                  # ZSH configuration
├── bootstrap.sh               # Setup script
├── private_dot_ssh/           # SSH configs
│   └── private_github.tmpl    # GitHub SSH key (from Bitwarden)
└── private_dot_config/        # Various configs
    └── mise/
        └── config.toml        # mise tool versions
```

## 🎨 Customization

Feel free to fork and modify. Just remember:

> *"Good artists copy, great artists steal, but the best artists properly attribute their dotfiles sources in the README."*
> 
> — Abraham Lincoln (probably)

## 🐛 Troubleshooting

**Q: It doesn't work!**  
A: Have you tried turning it off and on again?

**Q: Bitwarden says "Error parsing encoded request data"**  
A: Use `output` not `exec` in your chezmoi templates, rookie mistake.

**Q: ZSH parse error about `bw-unlock`**  
A: Don't define both an alias AND a function with the same name. Pick one.

**Q: Why are there memes in this README?**  
A: Because maintaining dotfiles without humor leads to madness.

![Suffering from success - DJ Khaled](https://i.imgflip.com/2/2fvqmr.jpg)

## 📝 License

MIT or whatever. Do what you want, I'm not your mom.

---

<div align="center">

*Made with ☕, 😤, and a questionable amount of procrastination*

![They don't know I spent 3 hours configuring my dotfiles instead of working](https://i.imgflip.com/2/3sijzd.jpg)

</div>