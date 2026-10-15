# Fish tab completion for tmux
# Completes tmux subcommands (and their aliases) plus session names after -t/-s

# Print the names of running tmux sessions (empty if no server is running)
function __tmux_sessions
    tmux list-sessions -F '#S' 2>/dev/null
end

# Subcommands (and aliases) offered only when no subcommand has been typed yet
complete -c tmux -f -n __fish_use_subcommand -a "attach-session attach detach-client detach has-session has kill-server kill-session kill-window killw kill-pane killp list-clients lsc list-commands lscm list-sessions ls list-windows lsw list-panes lsp new-session new new-window neww rename-session rename rename-window renamew switch-client switchc send-keys send split-window splitw select-pane selectp select-window selectw last-pane lastp last-window last source-file source show-options show set-option set set-window-option setw display-message display copy-mode clock-mode resize-pane resizep swap-pane swapp swap-window swapw move-window movew respawn-pane respawnp respawn-window respawnw choose-tree command-prompt run-shell run if-shell if capture-pane capturep pipe-pane pipep" -d "tmux command"

# Session-name completion for the target/source session options
complete -c tmux -x -s t -a "(__tmux_sessions)" -d "Target session"
complete -c tmux -x -s s -a "(__tmux_sessions)" -d "Source session"

# Being first in $fish_complete_path, this file hides fish's own tmux
# completions, so load the next tmux.fish too (or fish 4's built-in copy)
set -l __tmux_builtin (path filter -f $fish_complete_path/tmux.fish)[2]
if test -n "$__tmux_builtin"
    source $__tmux_builtin
else
    status get-file completions/tmux.fish 2>/dev/null | source
end
