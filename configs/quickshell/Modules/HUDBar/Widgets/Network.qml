import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Common"
import "../../../Services"

Item {
    Layout.preferredWidth: networkLayout.implicitWidth
    Layout.preferredHeight: 30

    RowLayout {
        id: networkLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Icon {
            id: networkIcon
            size: 16
            Layout.alignment: Qt.AlignVCenter
            iconColor: NetworkService.connectionType === "disconnected" ? Colors.orange : Colors.fg1
            name: NetworkService.iconName
        }

        Text {
            id: netText
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 13
            font.family: "Cantarell"
            color: NetworkService.connectionType === "disconnected" ? Colors.orange : Colors.fg1

            text: {
                if (NetworkService.connectionType === "wifi") {
                    return NetworkService.ssid
                } else if (NetworkService.connectionType === "ethernet") {
                    return "Ethernet"
                }
                return "Disconnected"
            }
        }
    }

}
