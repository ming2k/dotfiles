import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    spacing: 12

    property string windowTitle: ""

    Text {
        id: titleText
        Layout.alignment: Qt.AlignVCenter
        Layout.maximumWidth: 300

        text: windowTitle
        color: "#d5c4a1"  // Gruvbox fg2 (slightly dimmed)
        font.pixelSize: 13
        font.family: "Cantarell"
        elide: Text.ElideRight
        maximumLineCount: 1
    }

    // Query focused window title periodically
    Process {
        id: windowQuery
        running: true
        command: ["sh", "-c", "niri msg -j windows | jq -r '.[] | select(.is_focused == true) | .title' 2>/dev/null || echo ''"]

        stdout: SplitParser {
            onRead: data => {
                windowTitle = data.trim()
            }
        }
    }

    Timer {
        interval: 500  // Update twice per second
        running: true
        repeat: true
        onTriggered: windowQuery.running = true
    }
}
