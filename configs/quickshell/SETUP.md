# Quickshell Configuration - Complete Setup

This Quickshell configuration follows the DankMaterialShell structure with Gruvbox theming and Papirus-Dark icons.

## Structure Overview

```
quickshell/
├── shell.qml                 # Main entry point
├── Common/                   # Shared components
│   ├── Colors.qml           # Gruvbox color scheme (singleton)
│   ├── Icon.qml             # Icon component using IconImage
│   └── qmldir
├── Services/                 # System integration singletons
│   ├── AudioService.qml     # Audio/volume management
│   ├── NetworkService.qml   # Network status monitoring
│   └── qmldir
├── Modules/                  # UI modules
│   ├── HUDBar/              # Top panel/bar
│   │   ├── HUDBar.qml
│   │   └── Widgets/         # Bar widgets
│   │       ├── Audio.qml
│   │       ├── Battery.qml
│   │       ├── Clock.qml
│   │       ├── Cpu.qml
│   │       ├── Memory.qml
│   │       ├── Network.qml
│   │       ├── SystemTray.qml
│   │       ├── WindowTitle.qml
│   │       └── Workspaces.qml
│   └── Notifications/       # Notification system
│       ├── NotificationManager.qml
│       └── qmldir
└── Modals/                   # Overlay windows
    └── OSD.qml              # On-screen display (disabled)

```

## Key Features

### 1. Icon Theme Integration
- **Theme**: Papirus-Dark (from `~/.local/share/icons/`)
- **Configuration**: `//@ pragma IconTheme Papirus-Dark` in shell.qml
- **Component**: Uses `Quickshell.Widgets.IconImage` for proper icon handling
- **Icon naming**: Papirus-specific names (e.g., `audio-volume-high-panel`, not `-symbolic`)

### 2. Color Scheme
- **Theme**: Gruvbox Dark
- **Implementation**: Centralized in `Common/Colors.qml` singleton
- **Usage**: All widgets use `Colors.fg1`, `Colors.bg0`, etc.

### 3. Service Architecture
- **AudioService**: Volume monitoring and control (wpctl/pactl)
- **NetworkService**: Network status (nmcli/iwctl/wpa_cli compatible)
- Both are singletons, automatically initialized

### 4. Widgets

#### HUDBar (Top Bar)
- **Left**: Workspaces (niri integration) + Window title
- **Center**: Clock with hover popup
- **Right**: System tray, Audio, Network, Battery

#### Notifications
- Slide-in animations
- Action buttons with hover effects
- Auto-dismiss after 5 seconds
- Right-click to close

### 5. Icon Naming Reference

For Papirus-Dark theme:

**Audio Icons:**
- `audio-volume-high-panel`
- `audio-volume-medium-panel`
- `audio-volume-low-panel`
- `audio-volume-muted-panel`

**Network Icons:**
- `network-wired-activated` (Ethernet)
- `network-wireless-signal-excellent` (WiFi 80-100%)
- `network-wireless-signal-good` (WiFi 60-80%)
- `network-wireless-signal-ok` (WiFi 40-60%)
- `network-wireless-signal-weak` (WiFi 20-40%)
- `network-offline` (Disconnected)

**Battery Icons:**
- Format: `battery-{percent}-charging` or `battery-{percent}`
- Percent is 3-digit (000, 010, 020, ..., 100)
- Examples: `battery-050`, `battery-080-charging`

**System Icons:**
- `cpu` or `processor`
- `memory` or `dialog-memory`

## Qt and Icon Theme Notes

### Why Papirus-Dark?
- Your gsettings is configured for Papirus-Dark
- Qt applications don't read gsettings automatically
- Must be explicitly configured via pragma or QS_ICON_THEME

### Icon Theme Priority
1. `//@ pragma IconTheme Papirus-Dark` in shell.qml
2. Environment variable: `export QS_ICON_THEME=Papirus-Dark`
3. System default (usually Adwaita)

### Icon Location
```bash
~/.local/share/icons/Papirus-Dark/   # User-level (used)
/usr/share/icons/                    # System-level
```

## Running Quickshell

```bash
# Start quickshell
quickshell

# With custom config
quickshell -c /path/to/shell.qml

# Check version
quickshell --version
```

## Troubleshooting

### Icons Not Loading
1. Verify icon theme is installed:
   ```bash
   ls ~/.local/share/icons/Papirus-Dark/
   ```

2. Check icon theme pragma in shell.qml:
   ```qml
   //@ pragma IconTheme Papirus-Dark
   ```

3. Test icon path resolution:
   ```bash
   # Icons should be in panel/ or status/ directories
   ls ~/.local/share/icons/Papirus-Dark/24x24/panel/
   ```

### Common Issues

**"Could not load icon" warnings:**
- Icon name doesn't exist in theme
- Using wrong suffix (e.g., `-symbolic` with Papirus)
- Icon theme not properly configured

**Shader errors:**
- Qt 6 doesn't support inline shaders
- Use `Quickshell.Widgets.IconImage` instead of custom ShaderEffect

**Deprecated properties:**
- Use `implicitWidth`/`implicitHeight` for PanelWindow
- Don't use `width`/`height` directly

## Customization

### Change Icon Theme
Edit `shell.qml` line 2:
```qml
//@ pragma IconTheme YourThemeName
```

### Change Colors
Edit `Common/Colors.qml` to use a different color scheme

### Add New Widgets
1. Create widget in `Modules/HUDBar/Widgets/`
2. Import in `HUDBar.qml`
3. Add to layout

## Dependencies

- quickshell >= 0.2.1
- Qt 6
- Icon theme (Papirus-Dark, Adwaita, etc.)
- Audio: wpctl or pactl
- Network: nmcli, iwctl, or wpa_cli
- Niri compositor (for workspace widget)

## Credits

Based on [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) architecture with custom implementation.
