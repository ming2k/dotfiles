import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../../Common"

RowLayout {
    spacing: 8

    Icon {
        id: cpuIcon
        size: 16
        Layout.alignment: Qt.AlignVCenter
        iconColor: Colors.fg1
        name: "cpu"
        fallback: "processor"
    }

    Text {
        id: cpuText
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: 13
        font.family: "Cantarell"
        color: Colors.fg1

        text: "--"
    }
}
