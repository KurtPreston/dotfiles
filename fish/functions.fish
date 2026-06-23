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

    # Build clean excludes: always keep env/editor config, plus any filenames
    # listed in $GRR_IGNORE (colon-separated) so a machine can preserve its own
    # persistent files (e.g. GRR_IGNORE="myPersistentConfig.json:secrets.yml").
    set -l clean_excludes -e .env -e .vscode/settings.json
    if set -q GRR_IGNORE; and test -n "$GRR_IGNORE"
        for pattern in (string split ':' -- $GRR_IGNORE)
            test -n "$pattern"; and set -a clean_excludes -e $pattern
        end
    end

    # Remove any lingering files or folders
    git clean -xffd $clean_excludes
    git submodule foreach --recursive git clean -xffd
end

# Alias for git_recursive_reset
alias grr="git_recursive_reset"

# Kill process listening on a port
# Usage: killport 8080
function killport --description "Kill process listening on a port"
    lsof -i TCP:$argv[1] | grep LISTEN | awk '{print $2}' | xargs kill -9
end

# wt - worktree-centric session manager
# The heavy lifting lives in bin/wt; this wrapper exists only so that
# navigation commands can change this shell's directory. bin/wt writes the
# target worktree path to $WT_CD_FILE, which we read and cd into here.
function wt --description "worktree-centric session manager"
    set -l wt_file (mktemp)
    set -lx WT_CD_FILE $wt_file
    command wt $argv
    set -l wt_status $status
    set -e WT_CD_FILE
    if test -s "$wt_file"
        set -l wt_dest (cat "$wt_file")
        test -d "$wt_dest"; and cd "$wt_dest"
    end
    rm -f "$wt_file"
    return $wt_status
end 