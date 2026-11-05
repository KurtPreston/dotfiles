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
set -g __fish_prompt_colors_gray (set_color brblack)

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

# In a grove project (an ancestor holding a bare .base repo, beside one
# worktree per branch) outside any worktree, prints "grove×N", N being the
# worktree count. Fails when not in a grove project.
function __grove_prompt_label
    set -l dir $PWD

    # Walk up to the directory holding .base, as grove itself does
    while test -n "$dir"; and not test -d "$dir/.base"
        set dir (string replace -r '/[^/]*$' '' -- $dir)
    end
    test -n "$dir"; or return 1

    # A glob with no matches expands to an empty list inside set
    set -l worktrees $dir/.base/worktrees/*/
    if test (count $worktrees) -gt 0
        echo "grove×"(count $worktrees)
    else
        echo grove
    end
end

# Branch name, colored green when clean, red when tracked files have unstaged
# or conflicted changes, and gray while that's unknown. The branch takes two
# quick git calls, looked up once per prompt by __git_prompt_update.
# `git status` can take seconds in a large repo, so bin/git-prompt-dirty runs
# it in the background and signals SIGUSR1 to repaint once it answers. Until
# then the prompt keeps the last answer for the same work tree, or gray.
set -g __git_prompt_branch ""
set -g __git_prompt_top ""
set -g __git_prompt_grove ""
set -g __git_prompt_known_top ""
set -g __git_prompt_known_state ""
set -g __git_prompt_pending_top ""
set -g __git_prompt_rerun 0
set -g __git_prompt_result_file (string trim -r -c / -- (set -q TMPDIR; and echo $TMPDIR; or echo /tmp))/git-prompt-fish.$fish_pid

# Starts a background dirty check for work tree $top. If one is already
# running there, it reruns once finished instead, since the command just run
# may have changed files after it started.
function __git_prompt_async_start --argument-names top
    if test "$__git_prompt_pending_top" = "$top"
        set -g __git_prompt_rerun 1
        return
    end
    set -g __git_prompt_pending_top $top
    set -g __git_prompt_rerun 0

    # sh backgrounds the check itself, so fish has no job to track or report.
    # It writes "state<TAB>top" atomically, then signals this shell.
    sh -c '(
        state=$("$HOME/.dotfiles/bin/git-prompt-dirty" "$1" 2>/dev/null)
        printf "%s\t%s\n" "$state" "$1" > "$2.$$" && mv -f "$2.$$" "$2"
        kill -USR1 "$3"
    ) </dev/null >/dev/null 2>&1 &' sh $top $__git_prompt_result_file $fish_pid
end

# Records the background check's answer and repaints the prompt. Answers for a
# work tree no longer being checked are dropped.
function __git_prompt_async_done --on-signal SIGUSR1
    read --delimiter \t -l state top <$__git_prompt_result_file; or return
    test "$top" = "$__git_prompt_pending_top"; or return
    set -g __git_prompt_pending_top ""
    set -g __git_prompt_known_top $top
    set -g __git_prompt_known_state $state

    # Check again if a prompt asked while this one was running.
    if test $__git_prompt_rerun -eq 1 -a "$top" = "$__git_prompt_top"
        __git_prompt_async_start $top
    end
    commandline -f repaint
end

function __git_prompt_cleanup --on-event fish_exit
    command rm -f $__git_prompt_result_file
end

# Looks up the branch before each new prompt (not on repaints) and starts the
# dirty check.
function __git_prompt_update --on-event fish_prompt
    set -g __git_prompt_branch ""
    set -g __git_prompt_top ""
    set -g __git_prompt_grove ""

    # rev-parse prints "true" and the root in a work tree, "false" inside .git
    # or a bare repo, and nothing outside a repository.
    set -l info (__git_prompt_run rev-parse --is-inside-work-tree --show-toplevel 2>/dev/null)
    switch "$info[1]"
        case true
            set -g __git_prompt_top $info[2]
        case false
        case '*'
            set -g __git_prompt_grove (__grove_prompt_label)
            return 0
    end

    # Exit status 0 means on a branch, 1 a detached HEAD.
    set -l branch (__git_prompt_run symbolic-ref --short -q HEAD 2>/dev/null)
    set -l rc $status
    test $rc -gt 1; and return 0
    if test $rc -eq 1
        set branch (__git_branch_at_head)
        if test -z "$branch"
            set branch (__git_prompt_run rev-parse --short HEAD 2>/dev/null)
        end
        set branch "$branch (detached)"
    end
    set -g __git_prompt_branch $branch

    test -n "$__git_prompt_top"; and __git_prompt_async_start $__git_prompt_top
end

# Renders the "[branch] " segment from the state __git_prompt_update and the
# background check left.
function git_prompt
    # Outside a repository, show the grove label (if any) in yellow.
    if test -z "$__git_prompt_branch"
        test -n "$__git_prompt_grove"
        and echo -n "[$__fish_prompt_colors_yellow$__git_prompt_grove$__fish_prompt_colors_default] "
        return 0
    end
    set -l color $__fish_prompt_colors_gray

    # No work tree (inside .git, or a bare repo) can't report changes, so red.
    if test -z "$__git_prompt_top"
        set color $__fish_prompt_colors_red
    else if test "$__git_prompt_known_top" = "$__git_prompt_top"
        switch "$__git_prompt_known_state"
            case dirty
                set color $__fish_prompt_colors_red
            case clean
                set color $__fish_prompt_colors_green
        end
    end

    echo -n "[$color$__git_prompt_branch$__fish_prompt_colors_default] "
end

# Show hostname if remote connection
function show_host_if_remote
    if test -n "$SSH_CONNECTION"
        # PROMPT_HOST overrides the hostname
        set -l host $PROMPT_HOST
        test -n "$host"; or set host (hostname)
        echo -n "$__fish_prompt_colors_blue$host$__fish_prompt_colors_default"
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