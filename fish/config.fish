# Fish configuration file
# This file is sourced by fish

# Source shared environment variables using bass for bash compatibility
if type -q bass
    bass source ~/.dotfiles/shared/env
else
    echo "Warning: bass not found. Install bass for proper environment variable support in fish."
    # Fallback: set CODE_HOME manually if not set
    if not set -q CODE_HOME
        set -gx CODE_HOME $HOME/Code
    end
end

# Source shared aliases
source ~/.dotfiles/shared/aliases

# Source fish-specific aliases
source ~/.dotfiles/fish/aliases

# Source fish-specific functions
source ~/.dotfiles/fish/functions.fish

# Load NVM if available (Fish shell approach)
if test -s ~/.nvm/nvm.sh
    # For Fish, we need to use bass to run nvm commands or use fisher nvm plugin
    # This sets up the NVM_DIR variable for compatibility
    set -gx NVM_DIR ~/.nvm
    
    # Source nvm script using bass if available, otherwise skip
    if type -q bass
        bass source ~/.nvm/nvm.sh
    end
end

# Source local configuration if it exists (before tab completion to allow CODE_HOME override)
if test -f ~/.localrc
    source ~/.localrc
end

# Source tab completion functions (after local config to use any CODE_HOME override)
for file in ~/.dotfiles/fish/tabcomplete*
    source $file
end

# Source fish prompt configuration
source ~/.dotfiles/fish/prompt.fish

# Fish-specific configuration can be added here 