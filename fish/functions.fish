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