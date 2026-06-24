# tmux Cheat Sheet

Tailored to this repo's [`tmux.conf`](./tmux.conf).

> **Prefix is `Ctrl-a`** (remapped from the default `Ctrl-b`).
> Notation: `<prefix> x` means press `Ctrl-a`, release, then press `x`.
> Keys marked **(repeatable)** can be pressed again without re-pressing the prefix.

---

## Windows (tabs)

| Action | Keys |
| --- | --- |
| New window | `<prefix> c` |
| Next window | `<prefix> n` |
| Previous window | `<prefix> p` |
| Switch to window by number | `<prefix> 0`–`9` |
| Choose window from list | `<prefix> w` |
| Last (most recent) window | `<prefix> l`* |
| Rename current window | `<prefix> ,` |
| **Close window** | `<prefix> &` (confirm `y`) |
| Find window by name | `<prefix> f` |

\* Note: in this config `<prefix> l` is remapped to **select pane right** (vim-style), so the default "last window" binding is overridden. Use `<prefix> n`/`p` or numbers instead.

---

## Panes (splits)

| Action | Keys |
| --- | --- |
| Split vertically (side by side) | `<prefix> \|` |
| Split horizontally (stacked) | `<prefix> -` |
| Move to pane **left** | `<prefix> h` |
| Move to pane **down** | `<prefix> j` |
| Move to pane **up** | `<prefix> k` |
| Move to pane **right** | `<prefix> l` |
| Cycle through panes | `<prefix> o` |
| Show pane numbers (then press number to jump) | `<prefix> q` |
| **Close current pane** | `<prefix> x` (confirm `y`) — or type `exit` |
| Toggle pane zoom (fullscreen) | `<prefix> z` |
| Convert pane into its own window | `<prefix> !` |
| Swap pane with next | `<prefix> }` |
| Swap pane with previous | `<prefix> {` |

New splits open in the **current pane's working directory**.

---

## Resizing panes

These are **repeatable** — hold the direction key to keep resizing after the prefix:

| Action | Keys |
| --- | --- |
| Grow pane **left** by 5 | `<prefix> H` *(repeatable)* |
| Grow pane **down** by 5 | `<prefix> J` *(repeatable)* |
| Grow pane **up** by 5 | `<prefix> K` *(repeatable)* |
| Grow pane **right** by 5 | `<prefix> L` *(repeatable)* |

Mouse is enabled, so you can also **drag pane borders** to resize and **click** to select panes/windows.

---

## Sessions

| Action | Keys |
| --- | --- |
| Detach (leave tmux running) | `<prefix> d` |
| List / switch sessions | `<prefix> s` |
| Rename session | `<prefix> $` |
| Next / previous session | `<prefix> )` / `<prefix> (` |
| New session (from shell) | `tmux new -s name` |
| Attach to a session (from shell) | `tmux attach -t name` |
| List sessions (from shell) | `tmux ls` |
| Kill a session (from shell) | `tmux kill-session -t name` |

---

## Exiting

| Action | How |
| --- | --- |
| Close a pane | type `exit` / `Ctrl-d`, or `<prefix> x` |
| Close a window | close all its panes, or `<prefix> &` |
| Leave tmux but keep it running | `<prefix> d` (detach) |
| Kill the whole server (from shell) | `tmux kill-server` |

---

## Copy mode (scrollback)

| Action | Keys |
| --- | --- |
| Enter copy mode | `<prefix> [` |
| Scroll / move | arrow keys, `PgUp`/`PgDn` |
| Start selection (vi-style) | `Space` |
| Copy selection | `Enter` |
| Paste | `<prefix> ]` |
| Quit copy mode | `q` |

You can also scroll with the **mouse wheel** since mouse mode is on.
History limit is **50,000** lines.

---

## Misc

| Action | Keys |
| --- | --- |
| Reload tmux config | `<prefix> r` |
| Command prompt | `<prefix> :` |
| List all key bindings | `<prefix> ?` |
| Clock | `<prefix> t` |

---

## This config at a glance

- Prefix: **`Ctrl-a`** (send a literal `Ctrl-a` to the app with `<prefix> Ctrl-a`)
- Windows & panes are **1-indexed** and renumber automatically when one closes
- Mouse support is **on**
- True color enabled (`tmux-256color`)
