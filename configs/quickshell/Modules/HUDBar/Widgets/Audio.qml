import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Common"
import "../../../Services"

RowLayout {
    spacing: 6
    Layout.preferredHeight: 30

    Icon {
        id: audioIcon
        size: 16
        Layout.alignment: Qt.AlignVCenter
        iconColor: Colors.fg1
        name: AudioService.iconName
    }

    Text {
        id: audioText
        Layout.alignment: Qt.AlignVCenter
        color: Colors.fg1
        font.pixelSize: 13
        font.family: "Cantarell"
        text: AudioService.isMuted ? "Muted" : `${AudioService.volumeLevel}%`
    }

    MouseArea {
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: AudioService.toggleMute()
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                AudioService.increaseVolume()
            } else if (wheel.angleDelta.y < 0) {
                AudioService.decreaseVolume()
            }
        }
    }
}
