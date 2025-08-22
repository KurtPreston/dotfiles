# Dotfiles

A standard prompt, config, and aliases for bash, zsh, and fish shells.

## Installation

1. Clone the repository anywhere you prefer:
   ```bash
   mkdir ~/Code
   git clone git@github.com:KurtPreston/dotfiles.git ~/Code/dotfiles
   cd ~/Code/dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The script will:
- Create a symlink from `~/.dotfiles` to your cloned repository
- Create symlinks for the appropriate configuration files
- Back up any existing configuration files
- Install shared aliases

## Features

### Prompt

Simple terminal prompt showing git branch, user, and dir.

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `c <DIR>` | `cd $CODE_HOME/<DIR>` | Quick jump to a repo in your ~/Code/ folder |
| `g` | `git` | Git command shorthand |
| `ga` | `git add` | Stage files for commit |
| `gb` | `git branch` | List or manage branches |
| `gc` | `git commit` | Commit staged changes |
| `gco` | `git checkout` | Switch branches or restore files |
| `gd` | `git diff` | Show unstaged changes |
| `gdc` | `git diff --cached` | Show staged changes |
| `gs` | `git status` | Show repository status |
| `gl` | `git log --oneline` | Show commit history in one line |
| `grr` | `git_recursive_reset` | Aggressively reset project and submodules |
| `gsi` | `git stash-index` | Stashes currently staged code |
| `gbc` | `git-branch-clean` | Clean local and remote merged branches |
| `gbcl` | `git-branch-clean-local` | Clean local merged branches only |
| `gbcr` | `git-branch-clean-remote` | Clean remote merged branches only |
| `cr` | `cd_git_root` | Change to git repository root |
| `l` | `ls -al` | List all files with details |
| `reload` | `source ~/.dotfiles/*/config` | Reload shell configuration |

### Functions

| Function | Description |
|----------|-------------|
| `killport <PORT>` | Kill process listening on a specific port |
| `git_recursive_reset` | Aggressively reset project and submodules |
| `git stash-index` | Stashes currently staged code |

## Structure

```
dotfiles/
├── install.sh          # Installation script
├── bin/                # Executable scripts
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

## Local overrides

Any config you don't want stored in the repo, such as environment variables or local aliases can be put in a file `~/.localrc`.

## Adding Aliases

Add your aliases to `shared/aliases`. This file is sourced by all shells, so you can write aliases that work across bash, zsh, and fish.

For functions designed to work in a specific shell,
- **Bash**: Add bash-specific configuration to `bash/bashrc` or `bash/bash_profile`
- **Zsh**: Add zsh-specific configuration to `zsh/zshrc`
- **Fish**: Add fish-specific configuration to `fish/config.fish`