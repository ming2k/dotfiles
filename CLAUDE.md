# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a shareable dotfiles repository that manages configuration files for a Linux desktop environment, primarily focused on Sway (Wayland compositor) and associated tools. The repository has been structured for easy sharing and installation, with personal information sanitized.

**Note**: Neovim configuration has been deliberately excluded from this repository. Neovim configs tend to be highly personal, complex, and large (often 100+ files with plugins, LSP configurations, and custom scripts). They deserve dedicated repositories and are better maintained separately from system-level dotfiles.

## Key Commands

### Sync System
- **List configurations**: `./sync.sh list` - Shows all available configurations
- **Install configurations**: `./sync.sh install [configs...]` - Install configs from repo to system
- **Backup configurations**: `./sync.sh backup [configs...]` - Backup system configs to repo
- **Check status**: `./sync.sh status [configs...]` - Check sync status
- **Configuration file**: `sync_config.toml` - Controls sync behavior and destinations

### Common Usage
```bash
# Install all configurations
./sync.sh install

# Install specific configurations
./sync.sh install sway tmux

# Backup current system configs
./sync.sh backup --exclude-personal

# Dry run to see what would happen
./sync.sh install --dry-run
```

## Architecture & Structure

### Directory Structure
```
configs/
├── sway/             # Sway window manager
├── waybar/           # Status bar themes
├── swaylock/         # Screen locker
├── mako/             # Notifications (Mako)
├── dunst/            # Notifications (Dunst)
├── tmux/             # Terminal multiplexer
├── kitty/            # Kitty terminal
├── alacritty/        # Alacritty terminal
├── zsh/              # Zsh configuration
├── bash/             # Bash configuration
├── rofi/             # Application launcher
├── mpv/              # Media player
├── fontconfig/       # Font configuration
└── themes/           # Themes and assets
```

### Configuration Management

The sync system uses `sync_config.toml` which defines:
- Source paths in the system (e.g., `$HOME/.config/`)
- Destination paths within `configs/`
- Exclusion patterns to avoid syncing unnecessary files
- Enable/disable flags for each configuration

Key features:
- Automatic exclusion of cache files, logs, and build artifacts
- Personal information sanitization with `--exclude-personal` flag
- Dry-run mode for safe testing
- Selective sync of specific configurations

### Terminal Configuration

Terminal-focused configurations:
- **Tmux**: Session management with custom key bindings and themes
- **Kitty/Alacritty**: Modern terminal emulators with optimized settings
- **Shell configs**: Zsh and Bash with useful aliases and prompt customization

### Sway Window Manager

Modular configuration with config.d/ structure:
- `config` - Main configuration file with includes
- `config.d/appearance.conf` - Theme and visual settings
- `config.d/keybind.conf` - Keyboard shortcuts
- `config.d/monitor.conf` - Display configuration
- `config.d/window_rule.conf` - Window management rules
- All hardcoded paths use `~/.config/` instead of absolute paths

### Waybar Themes

Multiple themed configurations:
- `light-sway/` - Clean light theme with design guidelines
- `separated-dark-sway/` - Dark theme with separated modules
- `snow-hypr/` - Snow theme for Hyprland compatibility
- Each theme includes config, styling, and utility scripts

## Personal Information Handling

The repository has been sanitized to remove:
- Email addresses (replaced with `USER@DOMAIN.COM`)
- Hardcoded home directory paths (use `~/` instead)
- GitHub usernames (replaced with `USERNAME`)
- Personal names in snippets (replaced with placeholders)

Use `./sync.sh backup --exclude-personal` to maintain this sanitization when updating from your system.