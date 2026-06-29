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

### Shared history

Commands are written to a single shared history file the moment they run, so
`Ctrl+R` (fzf) finds commands typed in *any* terminal. The `Up` arrow stays
local: it only walks the commands typed in *this* terminal, because other
sessions are never merged back into the current session's in-memory history.
Configured in `bash/history` and `zsh/history`. (Fish already shares history
across terminals natively.)

### tmux

A minimal `tmux.conf` (symlinked to `~/.tmux.conf`) with sensible ergonomics.
The prefix is remapped from `Ctrl+b` to **`Ctrl+a`**.

| Binding | Action |
|---------|--------|
| `prefix \|` | Split pane vertically (in the current path) |
| `prefix -` | Split pane horizontally (in the current path) |
| `prefix h/j/k/l` | Move between panes (Vim style) |
| `prefix H/J/K/L` | Resize the current pane (repeatable) |
| `prefix r` | Reload `~/.tmux.conf` |

Also enables mouse support, 1-based gap-free window/pane numbering, a 50k-line
scrollback, faster escape-time for Vim/Neovim, true color, and a minimal status
bar.

Tab completion for the `tmux` command is provided in all three shells (bash,
zsh, and fish): the first argument completes tmux subcommands and their short
aliases (e.g. `attach`, `lsw`, `killp`), and arguments after `-t`/`-s` complete
the names of running tmux sessions.

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
| `git_recursive_reset` | Aggressively reset project and submodules (honors `$GRR_IGNORE`) |
| `git stash-index` | Stashes currently staged code |

> **`git_recursive_reset` / `grr`**: Set the `GRR_IGNORE` environment variable to a colon-separated list of filenames or patterns that should never be removed by `git clean`. This is useful for keeping machine-specific files. For example, add `export GRR_IGNORE="myPersistentConfig.json:local-notes.md"` to your local shell config. The defaults (`.env` and `.vscode/settings.json`) are always preserved.

### Worktrees (`grove`)

The worktree workflow tool formerly bundled here now lives in its own
repo: [grove](https://github.com/KurtPreston/grove) (command `grove`).
These dotfiles automatically source grove's shell integration when it is installed
at `$CODE_HOME/grove` (see [`shared/functions`](shared/functions) and
[`fish/functions.fish`](fish/functions.fish)), and the tmux window colors in
[`tmux/tmux.conf`](tmux/tmux.conf) read the `@grove_bg`/`@grove_fg` options grove's
`tmux` recipe sets. Install grove from its repo to get the `grove` command.

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