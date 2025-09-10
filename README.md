# Dotfiles

[English](README.md) | [中文](README.zh-cn.md)

Shareable dotfiles for Linux desktop environment focused on Sway (Wayland compositor) and terminal tools.

## What's Included

- **Desktop**: Sway, Waybar, Swaylock, Mako/Dunst notifications
- **Terminal**: Tmux, Kitty, Alacritty, Zsh, Bash configs  
- **Apps**: Rofi, MPV, Font configuration

## How to Use `sync.sh`

### Quick Start
```bash
# See what's available
./sync.sh list

# Install all configurations  
./sync.sh install

# Install specific configs
./sync.sh install sway waybar tmux
```

### Commands
- `./sync.sh list` - Show available configurations
- `./sync.sh install [configs...]` - Install configs from repo to system
- `./sync.sh backup [configs...]` - Backup system configs to repo  
- `./sync.sh status [configs...]` - Check sync status
- `./sync.sh --dry-run` - Preview changes without applying

### Examples
```bash
# Install desktop environment
./sync.sh install sway waybar swaylock mako

# Install terminal setup
./sync.sh install tmux kitty zsh

# Backup your current configs
./sync.sh backup

# Preview what would be installed
./sync.sh install --dry-run

# Backup with personal info sanitized
./sync.sh backup --exclude-personal
```

### Configuration

Edit `sync_config.toml` to customize sync behavior, add/remove configurations, or change paths.


> [!WARNING]
> Maybe checking the result will encount error after you installed the config, this is because it may require some dependencies in config.


