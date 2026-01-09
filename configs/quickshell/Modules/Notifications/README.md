# Notification System

## Implementation

Following DankMaterialShell architecture, this notification system uses **Wayland Layer Shell** for proper popup positioning.

### Architecture

```
NotificationManager.qml
  └─> Creates NotificationPopup.qml for each notification
       └─> Uses WlrLayershell (Wayland Layer Shell)
```

### Key Components

**NotificationManager.qml**
- Listens for D-Bus notifications via `NotificationServer`
- Dynamically creates `NotificationPopup` instances
- Manages popup lifecycle (creation and cleanup)

**NotificationPopup.qml**
- Uses `WlrLayershell` for proper Wayland layer management
- Layer: `Overlay` (appears above other windows)
- Positioned at top center of screen
- Auto-dismisses after 5 seconds
- Smooth slide-in animation (scale + fade)

### Wayland Layer Shell Properties

```qml
layer: WlrLayershell.Overlay
namespace: "quickshell:notification-popup"
exclusiveZone: -1
keyboardFocus: WlrKeyboardFocus.None
```

**Why WlrLayershell?**
- PanelWindow has limited positioning capabilities
- WlrLayershell provides proper Wayland layer protocol support
- Allows notifications to appear in the Overlay layer
- Works correctly with Wayland compositors (niri, Hyprland, Sway)

### Visual Features

- **Position**: Top center, 50px margin
- **Width**: 400px (fixed)
- **Height**: Dynamic based on content
- **Animation**: Scale (0.95→1.0) + Fade (0→1) in 200ms
- **Colors**: Gruvbox theme via Colors singleton
- **Icon**: 48x48, themed with accent color
- **Auto-dismiss**: 5 seconds

### Usage

Notifications are automatically displayed when applications send D-Bus notifications:

```bash
# Basic notification
notify-send "Title" "Body text"

# Critical notification
notify-send -u critical "Important" "Critical message"

# With icon
notify-send -i dialog-warning "Warning" "Be careful"

# With action buttons
notify-send "Action Test" "Click me" --action="default=Open"
```

### Features

✅ Top-center positioning
✅ Wayland Layer Shell integration
✅ Smooth animations
✅ Click to close (✕ button)
✅ Action button support
✅ Auto-dismiss timer
✅ Gruvbox themed
✅ Icon support (Papirus-Dark)
✅ Multiple simultaneous notifications

### Differences from PanelWindow

| Feature | PanelWindow | WlrLayershell |
|---------|-------------|---------------|
| Positioning | Limited anchors | Full control |
| Layer | Fixed | Configurable (Overlay/Top/etc) |
| Centering | Difficult | Easy |
| Compositor Support | Limited | Full Wayland support |

### Debug

Enable debug logging in `NotificationManager.qml`:
```qml
onNotification: notification => {
    console.log("Notification received:", notification.summary)
    // ... rest of code
}
```

Check logs:
```bash
tail -f /run/user/1000/quickshell/by-id/*/log.qslog
```

### Known Limitations

- Multiple notifications stack on top of each other (no vertical spacing yet)
- No notification history/center
- No swipe-to-dismiss gesture
- Fixed 5-second timeout (not urgency-aware)

### Future Improvements

- [ ] Vertical stacking with proper spacing
- [ ] Notification center (persistent history)
- [ ] Swipe gestures for dismissal
- [ ] Urgency-based timeouts (critical = 10s)
- [ ] Sound effects
- [ ] Do Not Disturb mode
- [ ] Per-app notification settings

## References

- [DankMaterialShell Notifications](https://github.com/AvengeMedia/DankMaterialShell)
- [Quickshell WlrLayershell Documentation](https://quickshell.org/docs/)
