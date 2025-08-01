# Fish-specific functions file
# This file contains functions that work with fish shell syntax

# Directory navigation function
# Usage: c [DIR] - Navigate to CODE_HOME or to a specific directory within CODE_HOME
function c --description "Navigate to CODE_HOME or to a specific directory within CODE_HOME"
    if test (count $argv) -eq 0
        # No arguments: go to CODE_HOME
        cd "$CODE_HOME"
    else
        # With arguments: go to specific directory within CODE_HOME
        cd "$CODE_HOME/$argv[1]"
    end
end

# Aggressively reset project and submodules
function git_recursive_reset --description "Aggressively reset project and submodules"
    # Point all submodules to git commit
    git submodule update --recursive --init

    # Cancel any staged changes
    git reset --hard
    git submodule foreach --recursive git reset --hard

    # Remove any lingering files or folders
    git clean -xffd -e .env -e .vscode/settings.json
    git submodule foreach --recursive git clean -xffd
end

# Alias for git_recursive_reset
alias grr="git_recursive_reset" 