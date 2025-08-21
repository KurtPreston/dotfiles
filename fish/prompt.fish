# Fish prompt configuration
# This replicates the bash/zsh prompt functionality with safety improvements

# Text formatting params for fish
set -g __fish_prompt_colors
set -g __fish_prompt_colors_default (set_color normal)
set -g __fish_prompt_colors_red (set_color red)
set -g __fish_prompt_colors_green (set_color green)
set -g __fish_prompt_colors_yellow (set_color yellow)
set -g __fish_prompt_colors_blue (set_color blue)
set -g __fish_prompt_colors_purple (set_color purple)
set -g __fish_prompt_colors_cyan (set_color cyan)
set -g __fish_prompt_colors_white (set_color white)

# Parse git branch with timeout and error handling
function parse_git_branch
    # Use timeout to prevent hanging
    if command -v timeout >/dev/null
        timeout 1s git rev-parse --git-dir >/dev/null 2>&1
        if test $status -eq 0
            set gitver (timeout 1s git branch 2>/dev/null | sed -n '/^\*/s/^\* //p' | head -1)
        end
    else
        # Fallback without timeout
        if git rev-parse --git-dir >/dev/null 2>&1
            set gitver (git branch 2>/dev/null | sed -n '/^\*/s/^\* //p' | head -1)
        end
    end
    
    # If we're on a detached HEAD (gitver will be like "(HEAD detached at abc1234)")
    if test -n "$gitver"; and string match -rq '^\(HEAD detached at [a-f0-9]+\)$' "$gitver"
        set current_sha (git rev-parse HEAD 2>/dev/null)
        set short_sha (git rev-parse --short HEAD 2>/dev/null)
        if test -n "$current_sha"
            # Check if current SHA matches any local branch
            set matching_branch ""
            for branch in (git for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null)
                set branch_sha (git rev-parse "$branch" 2>/dev/null)
                if test "$branch_sha" = "$current_sha"
                    set matching_branch "$branch"
                    break
                end
            end
            
            if test -n "$matching_branch"
                set gitver "$matching_branch (detached)"
            else
                set gitver "$short_sha (detached)"
            end
        end
    end
    
    echo "$gitver"
end

# Get branch color based on git status with timeout
function branch_color
    if command -v timeout >/dev/null
        timeout 1s git rev-parse --git-dir >/dev/null 2>&1
        if test $status -eq 0
            timeout 1s git diff --quiet 2>/dev/null >&2
            if test $status -eq 0
                echo -n $__fish_prompt_colors_green
            else
                echo -n $__fish_prompt_colors_red
            end
        end
    else
        # Fallback without timeout
        if git rev-parse --git-dir >/dev/null 2>&1
            if git diff --quiet 2>/dev/null >&2
                echo -n $__fish_prompt_colors_green
            else
                echo -n $__fish_prompt_colors_red
            end
        end
    end
end

# Git prompt component with error handling
function git_prompt
    set -l branch (parse_git_branch)
    if test -n "$branch"
        set -l color (branch_color)
        echo -n "[$color$branch$__fish_prompt_colors_default] "
    end
end

# Show hostname if remote connection
function show_host_if_remote
    if test -n "$SSH_CONNECTION"
        echo -n "$__fish_prompt_colors_blue"(hostname)"$__fish_prompt_colors_default"
    end
end

# Show colored username
function show_colored_user
    set -l current_user (whoami)
    if test "$current_user" = "root"
        echo -n "$__fish_prompt_colors_red$current_user$__fish_prompt_colors_white"
    else
        echo -n "$__fish_prompt_colors_white$current_user"
    end
end

# Show colored path with ~ for home
function show_path
    set -l current_path (pwd)
    # Replace $HOME with ~ for cleaner display
    set -l home_short_path (string replace $HOME "~" $current_path)
    echo -n "$__fish_prompt_colors_cyan$home_short_path"
end

# Set the fish prompt with error handling
function fish_prompt
    # Use status command to check if we're in a git repo to avoid unnecessary calls
    set -l git_prompt_output ""
    if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
        set git_prompt_output (git_prompt)
    end
    
    set -l user_output (show_colored_user)
    set -l host_output (show_host_if_remote)
    set -l path_output (show_path)
    
    echo -n "$git_prompt_output$user_output@$host_output$path_output$__fish_prompt_colors_default: "
end 