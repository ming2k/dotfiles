pragma Singleton
import QtQuick

QtObject {
    // Gruvbox Dark Color Scheme
    // Background colors
    readonly property color bg0_hard: "#1d2021"
    readonly property color bg0: "#282828"
    readonly property color bg1: "#3c3836"
    readonly property color bg2: "#504945"
    readonly property color bg3: "#665c54"
    readonly property color bg4: "#7c6f64"

    // Foreground colors
    readonly property color fg0: "#fbf1c7"
    readonly property color fg1: "#ebdbb2"
    readonly property color fg2: "#d5c4a1"
    readonly property color fg3: "#bdae93"
    readonly property color fg4: "#a89984"

    // Neutral gray
    readonly property color gray: "#928374"

    // Accent colors (Gruvbox bright variants)
    readonly property color red: "#fb4934"
    readonly property color green: "#b8bb26"
    readonly property color yellow: "#fabd2f"
    readonly property color blue: "#83a598"
    readonly property color purple: "#d3869b"
    readonly property color aqua: "#8ec07c"
    readonly property color orange: "#fe8019"

    // Dim accent colors
    readonly property color red_dim: "#cc241d"
    readonly property color green_dim: "#98971a"
    readonly property color yellow_dim: "#d79921"
    readonly property color blue_dim: "#458588"
    readonly property color purple_dim: "#b16286"
    readonly property color aqua_dim: "#689d6a"
    readonly property color orange_dim: "#d65d0e"

    // Common UI colors
    readonly property color primary: bg0
    readonly property color secondary: bg1
    readonly property color accent: blue
    readonly property color text: fg1
    readonly property color textSecondary: fg2
    readonly property color textTertiary: fg3
    readonly property color border: bg3
    readonly property color separator: bg2

    // Transparency variants
    readonly property color transparent: "transparent"
    readonly property color overlay: "#aa282828"
    readonly property color overlayDark: "#dd1d2021"

    // Status colors
    readonly property color success: green
    readonly property color warning: yellow
    readonly property color error: red
    readonly property color info: blue

    // Widget-specific colors
    readonly property color barBackground: bg0
    readonly property color barAccent: blue
    readonly property color notificationBackground: bg0
    readonly property color notificationBorder: bg2
    readonly property color buttonBackground: bg1
    readonly property color buttonHover: bg2
    readonly property color buttonActive: bg3

    // Workspace colors
    readonly property color workspaceActive: "#285577"
    readonly property color workspaceActiveIndicator: "#4c7899"
    readonly property color workspaceInactive: transparent
    readonly property color workspaceOccupied: bg2
}
