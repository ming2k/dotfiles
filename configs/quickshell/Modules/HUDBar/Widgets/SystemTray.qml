import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../../../Common"

RowLayout {
    id: trayLayout
    spacing: 6

    // Access to parent window for menu anchoring
    property var parentWindow

    Repeater {
        model: SystemTray.items

        Rectangle {
            required property var modelData
            id: trayItem

            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter

            color: "transparent"
            radius: 4

            Icon {
                anchors.centerIn: parent
                name: modelData.icon || ""
                fallback: "application-x-executable"
                size: 16
                iconColor: Colors.fg1
            }

            // Menu anchor for right-click context menu
            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu

                anchor.window: trayLayout.parentWindow
                anchor.rect.width: 0
                anchor.rect.height: 0
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate()
                    } else if (mouse.button === Qt.RightButton) {
                        // Open context menu if available
                        if (modelData.menu) {
                            // Map mouse position to window coordinates
                            let windowPos = trayItem.mapToItem(trayLayout.parentWindow.contentItem, mouse.x, mouse.y)
                            menuAnchor.anchor.rect.x = windowPos.x
                            menuAnchor.anchor.rect.y = windowPos.y
                            menuAnchor.open()
                        }
                    }
                }
            }
        }
    }
}
