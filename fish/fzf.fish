# fzf integration for fish
# Key bindings require either fzf.fish (fisher install PatrickF1/fzf.fish)
# or the minimal Ctrl+R binding defined below.
# No-op if fzf is not installed.

if not type -q fzf
    exit
end

set -gx FZF_DEFAULT_OPTS '--height 40% --border --inline-info'

# If the fzf.fish plugin is installed its bindings take precedence; skip the
# minimal fallback so we don't double-bind Ctrl+R.
if functions -q _fzf_search_history
    exit
end

# Minimal Ctrl+R: fuzzy history search
function _fzf_history --description "Fuzzy history search"
    set -l query (commandline)
    set -l cmd (builtin history | fzf --tac --no-sort --query=$query --height 40% --border --prompt="history: ")
    if test -n "$cmd"
        commandline -- $cmd
    end
    commandline -f repaint
end

bind \cr _fzf_history

# gcof: interactive git branch checkout using fzf
function gcof --description "Fuzzy git branch checkout"
    set -l branch (git branch --all \
        | grep -v HEAD \
        | string trim \
        | string replace -r '^remotes/origin/' '' \
        | sort -u \
        | fzf --height 40% --border --prompt="checkout: ")
    test -n "$branch"; and git checkout $branch
end
