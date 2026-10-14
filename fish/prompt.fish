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

# Run git for prompt display, with a 1s cap when timeout is available.
function __git_prompt_run
    if command -v timeout >/dev/null
        timeout 1s git $argv
    else
        git $argv
    end
end

# Names the commit a detached HEAD is sitting on: a local branch on that commit
# if there is one, otherwise a remote-tracking branch, origin first.
# refs/remotes/<remote>/HEAD points at the remote's default branch rather than
# being a branch itself, and sorts ahead of the real ones, so filter it out.
function __git_branch_at_head
    set -l branch (__git_prompt_run for-each-ref --count=1 --format='%(refname:short)' --points-at HEAD refs/heads/ 2>/dev/null)
    if test -n "$branch"
        echo $branch
        return 0
    end

    set -l remotes (__git_prompt_run for-each-ref --format='%(refname:short)' --points-at HEAD refs/remotes/ 2>/dev/null | string match -v '*/HEAD')
    for ref in $remotes
        if string match -q 'origin/*' $ref
            echo $ref
            return 0
        end
    end

    if test (count $remotes) -gt 0
        echo $remotes[1]
    end
end

# Branch name plus green/red for clean/dirty, where dirty means unstaged or
# conflicted changes to tracked files. Each git call costs a full process
# start, so a single `git status` supplies both.
# status must keep its default optional locking (no GIT_OPTIONAL_LOCKS=0): that
# is what lets it write the refreshed index back, so after a pull or build
# touches many files only one prompt pays to re-check them. `git diff` can't
# repair files written in the same second as the index, and re-reads them on
# every prompt until something else rewrites it.
function git_prompt
    set -l color $__fish_prompt_colors_green
    set -l branch
    set -l rc 0
    set -l out (__git_prompt_run status --porcelain=v2 --branch --untracked-files=no --no-ahead-behind 2>&1)

    if test $status -eq 0
        set branch (string replace -rf '^# branch\.head ' '' -- $out)
        # Entries are "1 XY ..." / "2 XY ..." (Y is the unstaged state, '.'
        # when none) or "u ..." for conflicts; staged-only changes stay green.
        if string match -qr '^([12] .[^.]|u )' -- $out
            set color $__fish_prompt_colors_red
        end
        test "$branch" = "(detached)"; and set rc 1
    else
        string match -q '*not a git repository*' -- $out; and return 0
        # No work tree (inside .git, or a bare repo) or timeout gave up, so
        # status can't report changes. Exit status 0 means on a branch, 1 a
        # detached HEAD.
        set branch (__git_prompt_run symbolic-ref --short -q HEAD 2>/dev/null)
        set rc $status
        test $rc -gt 1; and return 0
        set color $__fish_prompt_colors_red
    end

    if test $rc -eq 1
        set branch (__git_branch_at_head)
        if test -z "$branch"
            set branch (__git_prompt_run rev-parse --short HEAD 2>/dev/null)
        end
        set branch "$branch (detached)"
    end

    echo -n "[$color$branch$__fish_prompt_colors_default] "
end

# Show hostname if remote connection
function show_host_if_remote
    if test -n "$SSH_CONNECTION"
        echo -n "$__fish_prompt_colors_blue"(hostname)"$__fish_prompt_colors_default"
    end
end

# Show colored username. Looked up once rather than forking whoami per prompt.
set -g __fish_prompt_user (whoami)
function show_colored_user
    if test "$__fish_prompt_user" = "root"
        echo -n "$__fish_prompt_colors_red$__fish_prompt_user$__fish_prompt_colors_white"
    else
        echo -n "$__fish_prompt_colors_white$__fish_prompt_user"
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
    set -l git_prompt_output (git_prompt)
    
    set -l user_output (show_colored_user)
    set -l host_output (show_host_if_remote)
    set -l path_output (show_path)
    
    echo -n "$git_prompt_output$user_output@$host_output$path_output$__fish_prompt_colors_default: "
end 