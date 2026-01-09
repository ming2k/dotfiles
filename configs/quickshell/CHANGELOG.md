# Quickshell Configuration - Changelog

## Summary

Complete Quickshell configuration based on DankMaterialShell structure with Gruvbox theme and Papirus-Dark icons.

## Fixed Issues ✅

### 1. Icon System
**Problem**: Icons not loading, using wrong naming convention, Qt 6 shader errors
**Solution**:
- Switched to `Quickshell.Widgets.IconImage` component
- Updated all icons to use Papirus-Dark naming (removed `-symbolic` suffixes)
- Added `//@ pragma IconTheme Papirus-Dark` to shell.qml
- Icon names now match Papirus theme:
  - Audio: `audio-volume-*-panel`
  - Network: `network-wired-activated`, `network-wireless-signal-*`
  - Battery: `battery-050`, `battery-080-charging` (numeric)
  - CPU/Memory: `cpu`, `memory`

### 2. Network Display
**Problem**: Network widget didn't show WiFi name (SSID) with iwd
**Solution**:
- Prioritized `iwctl` in NetworkService.qml
- Properly parse `iwctl station show` output
- Extract SSID from "Connected network" field
- Convert RSSI to percentage (0-100%)
- Display WiFi name in bar: "xunlisap"

### 3. Hover Effects
**Problem**: Unwanted background highlighting on hover
**Solution**:
- Removed hover background from Audio widget
- Removed hover background and tooltip from Network widget
- Widgets now static, no visual changes on hover

### 4. Notifications
**Problem**: Notifications not displaying
**Solution**:
- Fixed NotificationManager.qml height calculation
- Removed buggy visibility check
- Added debug logging
- Notifications now appear in top-right corner
- Slide-in animation working
- Auto-dismiss after 5 seconds

### 5. SystemTray
**Problem**: Menu errors: "Property 'open' is not a function"
**Solution**:
- Removed incorrect `menu.open()` call
- Use `activate()` for both left and right clicks
- Tray icons now work without errors

### 6. Deprecated Properties
**Problem**: QML warnings about width/height on PanelWindow
**Solution**:
- Changed `width`/`height` → `implicitWidth`/`implicitHeight`
- Fixed Audio.qml MouseArea to use Layout properties
- No more layout warnings

### 7. Qt 6 Compatibility
**Problem**: Inline GLSL shaders not supported in Qt 6
**Solution**:
- Removed ShaderEffect from Icon component
- Icons display in native theme colors
- No shader compilation errors

## Current Structure

```
quickshell/
├── shell.qml                    # Main entry (IconTheme: Papirus-Dark)
├── Common/
│   ├── Colors.qml              # Gruvbox color scheme singleton
│   ├── Icon.qml                # IconImage-based icon component
│   └── README.md               # Icon usage documentation
├── Services/
│   ├── AudioService.qml        # Audio/volume management
│   ├── NetworkService.qml      # Network status (iwd priority)
│   └── qmldir
├── Modules/
│   ├── HUDBar/
│   │   ├── HUDBar.qml
│   │   └── Widgets/
│   │       ├── Audio.qml       # Fixed layout, no hover
│   │       ├── Battery.qml     # Papirus numeric icons
│   │       ├── Clock.qml
│   │       ├── Cpu.qml         # Fixed icon name
│   │       ├── Memory.qml      # Fixed icon name
│   │       ├── Network.qml     # Shows WiFi SSID, no hover
│   │       ├── SystemTray.qml  # Fixed menu handling
│   │       ├── WindowTitle.qml
│   │       └── Workspaces.qml
│   └── Notifications/
│       ├── NotificationManager.qml  # Working with animations
│       └── qmldir
├── Modals/
│   ├── OSD.qml                 # (Disabled due to positioning issues)
│   └── qmldir
├── SETUP.md                    # Complete setup guide
└── CHANGELOG.md                # This file
```

## Features

### Working Features ✅
- **Top Bar**: Workspaces, window title, clock, system tray, audio, network, battery
- **Icons**: Papirus-Dark theme integration
- **Notifications**: Popup with slide-in animation, auto-dismiss
- **Audio**: Volume control via click (mute) and scroll (adjust)
- **Network**: WiFi SSID display, iwd integration
- **Battery**: Percentage-based icons with charging state
- **Colors**: Consistent Gruvbox theme throughout

### Known Limitations
- **OSD**: Disabled (FloatingWindow positioning issues)
- **SystemTray Menus**: Simplified to activate-only (menu API unclear)
- **Icon Colorization**: Disabled (no Qt5Compat dependency)

## Testing

Test notifications:
```bash
quickshell &
notify-send "Test" "Notification body"
notify-send -u critical "Critical" "Important message"
```

Test audio:
- Click audio widget to mute/unmute
- Scroll on audio widget to adjust volume

Test network:
- WiFi SSID displays automatically
- Updates every 3 seconds

## Dependencies

- quickshell >= 0.2.1
- Papirus-Dark icon theme (in ~/.local/share/icons/)
- iwd (for WiFi) or NetworkManager
- wpctl or pactl (for audio)
- Niri compositor (for workspaces)

## Environment

- Icon theme: Set via `//@ pragma IconTheme Papirus-Dark`
- Qt platform: Default (no gsettings integration)
- Colors: Gruvbox Dark (hardcoded in Colors.qml)

## Recent Changes (Latest Session)

1. Fixed all icon naming for Papirus-Dark theme
2. Implemented iwd-first network detection
3. Removed unwanted hover effects
4. Fixed notification display with proper animations
5. Fixed SystemTray menu errors
6. Updated all deprecated QML properties
7. Created comprehensive documentation

## Next Steps (Optional Improvements)

- [ ] Add brightness control widget
- [ ] Implement notification center (persistent history)
- [ ] Add keyboard shortcuts for common actions
- [ ] Create weather widget
- [ ] Add custom workspace switcher with preview
- [ ] Implement power menu
- [ ] Add media player controls

## Credits

Based on [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) architecture.
Gruvbox color scheme by morhetz.
Papirus icons by Papirus Development Team.
