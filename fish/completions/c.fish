# Fish tab completion functions

# Completion for 'c' alias
function __c_complete
    set -l code_home (test -n "$CODE_HOME"; and echo $CODE_HOME; or echo "$HOME/Code")

    # Only provide completions if CODE_HOME directory exists
    test -d "$code_home"; or return

    # Match directories (including nested paths) relative to CODE_HOME
    set -l token (commandline -ct)
    for dir in "$code_home"/$token*/
        string replace -- "$code_home/" "" $dir
    end
end

# Register completion for the 'c' alias
complete -c c -f -a "(__c_complete)" -d "Navigate to directory in CODE_HOME"
