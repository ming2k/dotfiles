# River Window Manager Configuration

A comprehensive configuration setup for the River dynamic tiling window manager on Wayland.

## Overview

This configuration provides a complete River window manager setup with:
- Dynamic tiling layout management using rivercarro
- Tag-based workspace system (1-9)
- Application-specific window rules and assignments
- Integrated desktop services (wallpaper, status bar, notifications)
- Power management and screen locking
- Custom keybindings optimized for productivity
- OCR functionality with Tesseract

## Features

### Window Management
- **Dynamic Tiling**: Uses rivercarro layout generator with configurable gaps
- **Tag System**: 9 workspaces with bit-based tag assignments
- **Smart Window Rules**: Automatic application placement and floating rules
- **Multi-Monitor Support**: Display configuration with wlr-randr

### Integrated Services
- **Waybar**: Status bar with custom styling
- **Mako**: Desktop notifications
- **swaybg**: Wallpaper management
- **swayidle/swaylock**: Power management and screen locking
- **fcitx5**: Input method support

### Productivity Tools
- **Screenshot**: Region and full-screen capture with grim/slurp
- **OCR**: High accuracy text recognition with Tesseract
- **Application Launcher**: wofi for quick app access

## Installation

### Prerequisites

Install River and required dependencies:

```bash
# Core window manager
sudo pacman -S river

# Layout manager
sudo pacman -S rivercarro

# Desktop services
sudo pacman -S waybar mako swaybg swayidle swaylock

# Screenshot and clipboard
sudo pacman -S grim slurp wl-clipboard

# Application launcher
sudo pacman -S wofi

# Input method (optional)
sudo pacman -S fcitx5

# OCR dependencies (optional)
sudo pacman -S tesseract tesseract-data-eng imagemagick
```

### Setup

1. Clone or copy this configuration to your River config directory:
   ```bash
   cp -r . ~/.config/river/
   ```

2. Make scripts executable:
   ```bash
   chmod +x ~/.config/river/scripts/*.sh
   ```

3. Ensure all shell scripts are executable:
   ```bash
   chmod +x ~/.config/river/*.sh
   ```

4. Create screenshots directory:
   ```bash
   mkdir -p ~/Pictures/screenshots
   ```

## Configuration Structure

```
~/.config/river/
├── init                    # Main configuration entry point
├── keybindings.sh         # Keyboard shortcuts and mappings
├── layout.sh              # Layout manager configuration
├── window-rules.sh        # Application-specific rules
├── desktop-services.sh    # Background services setup
├── preflight.sh           # Environment preparation
├── scripts/
│   └── ocr.sh            # OCR functionality
└── wallpapers/
    └── the-school-of-athens.jpg
```

## Key Bindings

### Window Management
- `Super + W`: Close window
- `Super + Tab/Period`: Focus next window
- `Super + Comma`: Focus previous window
- `Super + F`: Toggle floating
- `Super + Shift + F`: Toggle fullscreen

### Tags (Workspaces)
- `Super + 1-9`: Switch to tag
- `Super + Shift + 1-9`: Move window to tag
- `Super + Control + 1-9`: Toggle tag visibility

### Layout Control
- `Super + =/-`: Adjust main window ratio
- `Super + Shift + =/-`: Adjust main window count
- `Super + Arrow Keys`: Change layout orientation
- `Super + M`: Toggle monocle mode

### Applications
- `Super + Return`: Terminal (alacritty)
- `Super + A`: Application launcher (wofi)
- `Print`: Screenshot to clipboard
- `Shift + Print`: Screenshot to file

### Display Management
- `Super + Control + [/]`: Focus next/previous output
- `Super + Shift + [/]`: Send window to next/previous output

## OCR Usage

The included OCR script provides high-accuracy text recognition:

```bash
# Screenshot OCR to clipboard
./scripts/ocr.sh -s -c

# OCR a file with preprocessing
./scripts/ocr.sh -p image.png

# OCR with multiple languages
./scripts/ocr.sh -l eng+fra document.pdf

# Show help
./scripts/ocr.sh -h
```

## Application Tags

- **Tag 1**: Terminal and general applications
- **Tag 2**: Web browsers (Firefox, Chrome)
- **Tag 3**: Gaming and communication (Discord, Telegram, RetroArch)

## Customization

### Display Configuration
Edit `init` to modify display settings:
```bash
wlr-randr --output eDP-1 --mode 3072x1920@120Hz --scale 2 --pos 0,0
```

### Layout Gaps
Modify `layout.sh` to adjust window gaps:
```bash
rivercarro -inner-gaps 5 -outer-gaps 10 -per-tag &
```

### Wallpaper
Replace `wallpapers/the-school-of-athens.jpg` with your preferred image.

### Window Rules
Add custom application rules in `window-rules.sh`:
```bash
riverctl rule-add -app-id "your-app" float
riverctl rule-add -app-id "your-app" tags $((1 << 2))  # Tag 3
```

## Troubleshooting

### Common Issues

1. **Services not starting**: Check that all dependencies are installed
2. **Display issues**: Verify your display name with `wlr-randr`
3. **Input method not working**: Ensure fcitx5 is properly configured
4. **Screenshots not working**: Check grim and slurp installation

### Debugging

View River logs:
```bash
river > ~/.cache/river.log 2>&1
```

Test individual components:
```bash
# Test layout manager
rivercarro -inner-gaps 0 -outer-gaps 0

# Test screenshot
grim test.png

# Test OCR
tesseract test_image.png stdout
```

## Dependencies

See [CLAUDE.md](CLAUDE.md) for detailed information about the configuration architecture and development guidelines.

## License

This configuration is provided as-is for personal use and modification.