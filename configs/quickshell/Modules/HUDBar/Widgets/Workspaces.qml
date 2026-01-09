import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

// For full niri integration, install qml-niri:
// xbps-install -S qml-niri (or build from https://github.com/imiric/qml-niri)
// Then uncomment the Niri import and code below

// import Niri 0.1

RowLayout {
    id: workspaces
    spacing: 0

    property int activeWorkspace: 1
    property var activeWorkspaces: []  // List of workspaces that are in use

    // Loader for workspace switcher to avoid scoping issues
    Loader {
        id: switcherLoader
        active: false
        property int workspaceToSwitch: 1

        sourceComponent: Process {
            running: true
            command: ["niri", "msg", "action", "focus-workspace", switcherLoader.workspaceToSwitch.toString()]
            onExited: {
                switcherLoader.active = false
            }
        }
    }

    // ===== BASIC VERSION (no compositor integration) =====
    // Show only workspaces that are in use
    Repeater {
        model: workspaces.activeWorkspaces

        Rectangle {
            required property var modelData
            property int workspaceNum: modelData
            property bool isActive: workspaceNum === workspaces.activeWorkspace

            Layout.preferredWidth: 32
            Layout.preferredHeight: 30
            radius: 0  // Match waybar - no border radius

            color: isActive ? "#285577" : "transparent"  // Gruvbox blue bg when active

            // Border-top indicator (waybar style)
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: parent.isActive ? "#4c7899" : "transparent"  // Border color when active
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 1  // Compensate for border
                text: workspaceNum
                color: isActive ? "#ebdbb2" : "#928374"  // Gruvbox fg1 when active, gray otherwise
                font.pixelSize: 13
                font.family: "Cantarell"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let num = workspaceNum
                    switcherLoader.workspaceToSwitch = num
                    switcherLoader.active = true
                }
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    // Query workspaces periodically
    Process {
        id: workspaceQuery
        running: true
        command: ["sh", "-c", "niri msg -j workspaces | jq -c '{active: (.[] | select(.is_focused == true) | .idx), all: [.[] | .idx] | sort}'"]

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim()
                try {
                    let result = JSON.parse(output)
                    if (result.active !== undefined) {
                        workspaces.activeWorkspace = result.active
                    }
                    if (result.all && Array.isArray(result.all)) {
                        workspaces.activeWorkspaces = result.all
                    }
                } catch (e) {
                    console.log("Failed to parse workspace data:", e)
                }
            }
        }
    }

    Timer {
        interval: 100  // Update 10 times per second for snappier response
        running: true
        repeat: true
        onTriggered: workspaceQuery.running = true
    }

    // ===== NIRI VERSION (requires qml-niri plugin) =====
    // Uncomment this block after installing qml-niri for full functionality:
    // - Dynamic workspace list
    // - Active workspace highlighting
    // - Occupied workspace indicators
    // - Click to switch workspaces
    /*
    Niri {
        id: niri
        Component.onCompleted: connect()
    }

    Repeater {
        model: niri.workspaces

        Rectangle {
            required property var modelData

            Layout.preferredWidth: 28
            Layout.preferredHeight: 24
            radius: 2

            color: {
                if (modelData.isFocused) return Colors.accent
                if (modelData.windows && modelData.windows.length > 0) return Colors.bg2
                return "transparent"
            }

            border.width: 1
            border.color: (modelData.windows && modelData.windows.length > 0) ? Colors.bg3 : Colors.bg2

            Text {
                anchors.centerIn: parent
                text: modelData.idx + 1
                color: modelData.isFocused ? Colors.bg0 : Colors.fg2
                font.pixelSize: 12
                font.weight: modelData.isFocused ? Font.Bold : Font.Normal
            }

            MouseArea {
                anchors.fill: parent
                onClicked: niri.focusWorkspace(modelData.idx)
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }
    */
}
