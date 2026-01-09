import QtQuick
import QtQuick.Layouts
import Quickshell

// Match waybar style - simple clock with seconds, bold
Rectangle {
    width: timeText.implicitWidth + 20
    height: 30
    color: "transparent"

    property var currentDate: new Date()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: datePopup.visible = true
        onExited: datePopup.visible = false
        z: 2
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        color: "#ebdbb2"  // Gruvbox fg1
        font.pixelSize: 13
        font.family: "Cantarell"
        font.weight: Font.Bold
        z: 1

        function updateTime() {
            currentDate = new Date()
            text = Qt.formatDateTime(currentDate, "HH:mm:ss")
        }

        Component.onCompleted: updateTime()

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeText.updateTime()
        }
    }

    // Date/time details popup
    Rectangle {
        id: datePopup
        visible: false
        width: 220
        height: 120
        color: "#282828"  // Gruvbox bg0
        border.width: 2
        border.color: "#504945"  // Gruvbox bg2
        radius: 4
        z: 1000

        // Position below the clock
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 8

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: Qt.formatDateTime(currentDate, "dddd")
                color: "#ebdbb2"  // Gruvbox fg1
                font.pixelSize: 16
                font.family: "Cantarell"
                font.weight: Font.Bold
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: Qt.formatDateTime(currentDate, "MMMM d, yyyy")
                color: "#d5c4a1"  // Gruvbox fg2
                font.pixelSize: 14
                font.family: "Cantarell"
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#504945"
            }

            Text {
                text: Qt.formatDateTime(currentDate, "HH:mm:ss")
                color: "#ebdbb2"
                font.pixelSize: 20
                font.family: "Cantarell"
                font.weight: Font.Bold
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "Week " + Qt.formatDateTime(currentDate, "ww")
                color: "#928374"  // Gruvbox gray
                font.pixelSize: 11
                font.family: "Cantarell"
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
