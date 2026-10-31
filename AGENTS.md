# Agent guidelines

## Support bash, zsh, and fish

Every change must work in bash, zsh, and fish. Shared behavior for bash and zsh
goes in `shared/`; fish gets the equivalent in `fish/`. Validate the change in
all three shells before committing.

To load this repo's config in an interactive shell, whether or not `~/.bashrc`,
`~/.zshrc`, or `~/.config/fish/config.fish` are linked to it:

```sh
bash --rcfile ~/.dotfiles/bash/bashrc -i -c '<test>'
zsh -f -i -c 'source ~/.dotfiles/zsh/zshrc; <test>'
fish --no-config -i -c 'source ~/.dotfiles/fish/config.fish; <test>'
```

## Write scripts for macOS bash 3.2

Scripts in `bin/` run under `/usr/bin/env bash`, which on macOS is often bash
3.2. Under `set -u`, bash 3.2 treats an empty array as unbound, so
`"${arr[@]}"` aborts with `arr[@]: unbound variable`. Expand arrays that may be
empty with `${arr[@]+"${arr[@]}"}`, or check `${#arr[@]}` first. `${#arr[@]}`
is safe on empty arrays.

Test scripts with `/bin/bash` (3.2), including the empty case, before
committing.
