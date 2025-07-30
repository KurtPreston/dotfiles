# Fish configuration file
# This file is sourced by fish

# Source shared aliases
if test -f ~/.dotfiles/shared/aliases
    source ~/.dotfiles/shared/aliases
end

# Source fish-specific aliases
if test -f ~/.dotfiles/fish/aliases
    source ~/.dotfiles/fish/aliases
end

# Source tab completion functions
if test -f ~/.dotfiles/fish/tabcomplete
    source ~/.dotfiles/fish/tabcomplete
end

# Load NVM if available (Fish shell approach)
if test -s ~/.nvm/nvm.sh
    # For Fish, we need to use bass to run nvm commands or use fisher nvm plugin
    # This sets up the NVM_DIR variable for compatibility
    set -gx NVM_DIR ~/.nvm
    
    # Source nvm script using bass if available, otherwise skip
    if command -v bass >/dev/null
        bass source ~/.nvm/nvm.sh
    end
end

# Source local configuration if it exists
if test -f ~/.localrc
    source ~/.localrc
end

# Fish-specific configuration can be added here 