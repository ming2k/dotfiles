import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../Common"
import "Widgets"

Rectangle {
    id: hudBar
    color: Colors.barBackground

    // Window reference for menu anchoring
    property var window

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left section - Workspaces + Window title
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 0

            RowLayout {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
                spacing: 0

                Workspaces {
                    Layout.alignment: Qt.AlignVCenter
                }

                WindowTitle {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 12
                }
            }
        }

        // Center section - Clock
        Clock {
            Layout.alignment: Qt.AlignCenter
        }

        // Right section - System info modules
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 0

            RowLayout {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                spacing: 8

                SystemTray {
                    Layout.alignment: Qt.AlignVCenter
                    parentWindow: hudBar.window
                }

                Rectangle {
                    width: 1
                    height: 16
                    color: Colors.separator
                }

                Audio {
                    Layout.alignment: Qt.AlignVCenter
                }

                Network {
                    Layout.alignment: Qt.AlignVCenter
                }

                Battery {
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}
