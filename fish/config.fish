# Fish configuration file
# This file is sourced by fish

# Source shared aliases
if test -f ~/.dotfiles/shared/aliases
    source ~/.dotfiles/shared/aliases
end

# Source local configuration if it exists
if test -f ~/.localrc
    source ~/.localrc
end

# Fish-specific configuration can be added here 