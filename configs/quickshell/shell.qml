//@ pragma UseQApplication
//@ pragma IconTheme Papirus-Dark
import QtQuick
import Quickshell
import Quickshell.Wayland
import "Common"
import "Services"
import "Modules/HUDBar"
import "Modules/Notifications"

ShellRoot {
    // Initialize services
    Component.onCompleted: {
        // Services are singletons, so they're automatically initialized
        console.log("Quickshell config initialized")
    }

    // Top bar on each screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32
            color: "transparent"

            HUDBar {
                anchors.fill: parent
                window: panelWindow
            }
        }
    }

    // Notification system
    NotificationManager {}
}