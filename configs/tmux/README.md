# TMux Configuration Cheatsheet

## Prefix Key: `C-b`

---

## Pane Splitting

| Key | Action |
|-----|--------|
| `C-b \|` | Split horizontally (side by side) |
| `C-b -` | Split vertically (top/bottom) |

## Pane Navigation

| Key | Action |
|-----|--------|
| `C-b Arrow` | Move to pane in direction (default) |
| `C-b o` | Cycle through panes (default) |
| `C-b ;` | Go to last active pane (default) |
| `C-b q` + number | Jump to pane by number (default) |

## Pane Resizing

| Key | Action |
|-----|--------|
| `C-b C-Arrow` | Resize pane by 1 cell (default) |
| `C-b M-Arrow` | Resize pane by 5 cells (default) |
| Mouse drag border | Resize pane with mouse |

## Pane Position / Swapping

| Key | Action |
|-----|--------|
| `C-b {` | Swap pane with previous (default) |
| `C-b }` | Swap pane with next (default) |
| `C-b !` | Break pane to new window (default) |
| `C-b :join-pane -t :N` | Join pane to window N |

## Pane Management

| Key | Action |
|-----|--------|
| `C-b X` | Kill all panes except current |
| `C-b x` | Kill current pane (default) |
| `C-b z` | Toggle pane zoom (default) |
| `C-b q` | Show pane numbers (default) |

## Window Operations

| Key | Action |
|-----|--------|
| `C-b c` | Create new window (default) |
| `C-b &` | Kill window (with confirmation) |
| `C-b Tab` | Switch to last window |
| `C-b n/p` | Next/previous window (default) |
| `C-b 1-9` | Go to window number |

## Window Movement

| Key | Action |
|-----|--------|
| `C-b P` | Move window left |
| `C-b N` | Move window right |

## Layouts

| Key | Action |
|-----|--------|
| `C-b Space` | Next layout |
| `C-b C-Space` | Previous layout |
| `C-b M-1` | Even horizontal |
| `C-b M-2` | Even vertical |
| `C-b M-3` | Main horizontal |
| `C-b M-4` | Main vertical |
| `C-b M-5` | Tiled |
| `C-b =` | Tiled (shortcut) |
| `C-b +` | Main horizontal (shortcut) |

## Session Management

| Key | Action |
|-----|--------|
| `C-b s` | Choose session (tree view) |
| `C-b S` | Create new session / Toggle pane sync |
| `C-b d` | Detach (default) |

## Copy Mode (Emacs-style)

| Key | Action |
|-----|--------|
| `C-b [` | Enter copy mode (default) |
| `Escape` | Exit copy mode |
| `C-Space` | Begin selection |
| `C-w` / `M-w` | Copy selection and exit |
| `C-g` | Clear selection |
| `C-s` | Search forward (incremental) |
| `C-r` | Search backward (incremental) |
| Double-click | Select word |
| Triple-click | Select line |

## Utility

| Key | Action |
|-----|--------|
| `C-b r` | Reload config |
| `C-b C-l` | Clear screen and history |
| `C-b ?` | List keybindings (default) |

## Plugins (tmux-resurrect)

| Key | Action |
|-----|--------|
| `C-b C-s` | Save session |
| `C-b C-r` | Restore session |

---

## Configuration Overview

| Setting | Value |
|---------|-------|
| Mouse | Enabled |
| Windows | 1-indexed, auto-rename to directory |
| History | 50,000 lines |
| Theme | Gruvbox Dark |
| Copy mode | Emacs-style |
| Plugins | tpm, tmux-resurrect |

## File Structure

```
~/.config/tmux/
├── tmux.conf              # Main entry point
├── config/
│   ├── activity.conf      # Activity monitoring
│   ├── base.conf          # Base settings
│   ├── copy-mode.conf     # Copy mode bindings
│   ├── input.conf         # Mouse/keyboard settings
│   ├── keybindings.conf   # All keybindings
│   ├── performance.conf   # Performance tuning
│   ├── terminal.conf      # Terminal settings
│   ├── title.conf         # Title bar config
│   └── windows.conf       # Window/pane settings
└── themes/
    ├── status-bar-gruvbox-dark.conf   # Active theme
    ├── status-bar-gruvbox-light.conf
    ├── status-bar-nord.conf
    ├── status-bar-tokyo-night.conf
    ├── status-bar-azure-breeze.conf
    └── status-bar-charcoal.conf
```

## Notes

- The `S` key is bound to both `new-session` and `synchronize-panes` (potential conflict)
- Switch themes by editing `tmux.conf` and changing the sourced theme file
- Switch to vi-style copy mode by editing `config/copy-mode.conf`
