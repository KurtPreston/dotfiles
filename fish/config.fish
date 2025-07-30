# Fish configuration file
# This file is sourced by fish

# Source shared environment variables using bass for bash compatibility
if test -f ~/.dotfiles/shared/env
    if command -v bass >/dev/null
        bass source ~/.dotfiles/shared/env
    else
        echo "Warning: bass not found. Install bass for proper environment variable support in fish."
        # Fallback: set CODE_HOME manually if not set
        if not set -q CODE_HOME
            set -gx CODE_HOME $HOME/Code
        end
    end
end

# Source shared aliases
if test -f ~/.dotfiles/shared/aliases
    source ~/.dotfiles/shared/aliases
end

# Source fish-specific aliases
if test -f ~/.dotfiles/fish/aliases
    source ~/.dotfiles/fish/aliases
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

# Source local configuration if it exists (before tab completion to allow CODE_HOME override)
if test -f ~/.localrc
    source ~/.localrc
end

# Source tab completion functions (after local config to use any CODE_HOME override)
if test -f ~/.dotfiles/fish/tabcomplete
    source ~/.dotfiles/fish/tabcomplete
end

# Source fish prompt configuration
if test -f ~/.dotfiles/fish/prompt.fish
    source ~/.dotfiles/fish/prompt.fish
end

# Fish-specific configuration can be added here 