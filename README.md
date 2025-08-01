# Dotfiles

A clean, organized dotfiles repository that works with bash, zsh, and fish shells.

## Structure

```
dotfiles/
├── install.sh          # Installation script
├── bash/               # Bash-specific configuration
│   ├── bashrc         # Non-login shell configuration
│   └── bash_profile   # Login shell configuration
├── zsh/                # Zsh-specific configuration
│   └── zshrc          # Zsh configuration
├── fish/               # Fish-specific configuration
│   └── config.fish    # Fish configuration
└── shared/             # Shared configuration
    └── aliases         # Cross-shell aliases
```

## Installation

1. Clone the repository anywhere you prefer:
   ```bash
   git clone git@github.com:KurtPreston/dotfiles.git ~/Code/dotfiles
   cd ~/Code/dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The script will:
- Detect your current shell
- Create a symlink from `~/.dotfiles` to your cloned repository
- Create symlinks for the appropriate configuration files
- Back up any existing configuration files
- Install shared aliases

## Adding Aliases

Add your aliases to `shared/aliases`. This file is sourced by all shells, so you can write aliases that work across bash, zsh, and fish.

## Shell-Specific Configuration

- **Bash**: Add bash-specific configuration to `bash/bashrc` or `bash/bash_profile`
- **Zsh**: Add zsh-specific configuration to `zsh/zshrc`
- **Fish**: Add fish-specific configuration to `fish/config.fish`

## Features

- ✅ Simple installation with `./install.sh`
- ✅ Organized file structure
- ✅ Cross-shell compatibility (bash, zsh, fish)
- ✅ Shared aliases to avoid redundancy
- ✅ Automatic backup of existing configuration 