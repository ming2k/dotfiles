# Common Components

## Icon Component

The `Icon.qml` component provides a robust icon loading system using Quickshell's `IconImage` widget.

### Features

- **Built on IconImage**: Uses `Quickshell.Widgets.IconImage` for proper icon handling
- **Automatic Icon Resolution**: Uses `Quickshell.iconPath()` for theme icon loading
- **Fallback Support**: Automatically falls back if primary icon is missing
- **Path/URL Support**: Handles both icon names and direct file paths/URLs
- **Async Loading**: Icons load asynchronously for better performance
- **Mipmap Filtering**: Enabled for better quality when scaled down
- **Square Aspect Ratio**: Automatically maintains 1:1 aspect ratio with padding if needed

### Usage

```qml
import "../Common"

// Basic usage with icon name
Icon {
    name: "network-wired-symbolic"
    size: 16
    iconColor: Colors.fg1
}

// With custom fallback
Icon {
    name: "my-custom-icon"
    fallback: "application-x-executable"
    size: 24
    iconColor: Colors.accent
}

// With file path
Icon {
    name: "file:///path/to/icon.png"
    size: 32
}
```

### Properties

- `name` (string): Icon name or file path
- `fallback` (string): Fallback icon if primary fails (default: "")
- `size` (int): Icon size in pixels (default: 16)
- `iconColor` (color): Placeholder property for compatibility (not currently used)

### Icon Theme Configuration

To use a custom icon theme, add this to the top of your `shell.qml`:

```qml
//@ pragma IconTheme <theme-name>
```

Or set the environment variable:
```bash
export QS_ICON_THEME=<theme-name>
```

### Best Practices

1. **Use symbolic icons**: Prefer `-symbolic` suffix icons for consistency with system theme
2. **Provide fallbacks**: Always specify a fallback for custom icons
3. **Icon naming**: Use freedesktop icon naming spec for compatibility
4. **Size appropriately**: Use standard sizes (16, 24, 32, 48) for best results
5. **Install icon themes**: Ensure you have icon themes installed (e.g., `papirus-icon-theme`, `adwaita-icon-theme`)

## Colors Component

The `Colors.qml` singleton provides centralized Gruvbox theming.

### Usage

```qml
import "../Common"

Rectangle {
    color: Colors.bg0
    border.color: Colors.border
}

Text {
    color: Colors.fg1
}
```

### Available Colors

See `Colors.qml` for the full list of Gruvbox color definitions.
