# Grove tab completion (fish)
if test -f "$CODE_HOME/grove/shell/grove-completion.fish"
    source "$CODE_HOME/grove/shell/grove-completion.fish"
else if test -f "$HOME/Code/grove/shell/grove-completion.fish"
    source "$HOME/Code/grove/shell/grove-completion.fish"
else if set -q XDG_DATA_HOME; and test -f "$XDG_DATA_HOME/grove/grove-completion.fish"
    source "$XDG_DATA_HOME/grove/grove-completion.fish"
else if test -f "$HOME/.local/share/grove/grove-completion.fish"
    source "$HOME/.local/share/grove/grove-completion.fish"
end
