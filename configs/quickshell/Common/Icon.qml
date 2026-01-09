import QtQuick
import Quickshell
import Quickshell.Widgets

IconImage {
    id: root

    // Primary icon name or path
    property string name: ""

    // Fallback icon if primary fails
    property string fallback: ""

    // Icon size
    property int size: 16

    // Icon color (placeholder for compatibility - not used)
    property color iconColor: "white"

    // Placeholder for compatibility (not used)
    property bool enableColorization: false

    implicitSize: size
    asynchronous: true
    mipmap: true

    source: {
        if (!name) return ""

        // If it's already a full path or URL, use it directly
        if (name.indexOf("/") !== -1 || name.indexOf("://") !== -1) {
            return name
        }

        // Use Quickshell's iconPath function to resolve icon from theme
        let iconPath = Quickshell.iconPath(name)

        // If primary icon not found and fallback specified, try fallback
        if (!iconPath && fallback) {
            iconPath = Quickshell.iconPath(fallback)
        }

        return iconPath || ""
    }
}