import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../Common"

Item {
    id: osdRoot

    property string iconName: ""
    property string text: ""
    property int value: 0
    property bool showProgressBar: true

    signal show(string icon, string displayText, int progressValue, bool hasProgress)

    onShow: (icon, displayText, progressValue, hasProgress) => {
        iconName = icon
        text = displayText
        value = progressValue
        showProgressBar = hasProgress
        hideTimer.restart()
        osdWindow.visible = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: osdWindow
            property var modelData
            screen: modelData

            visible: false

            anchors {
                bottom: true
                horizontalCenter: true
            }

            margins {
                bottom: 100
            }

            width: 300
            height: 120
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: Colors.overlayDark
                radius: 8
                border.width: 2
                border.color: Colors.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        Icon {
                            name: osdRoot.iconName
                            size: 48
                            iconColor: Colors.fg1
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: osdRoot.text
                            color: Colors.fg1
                            font.pixelSize: 18
                            font.family: "Cantarell"
                            font.weight: Font.Bold
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 8
                        color: Colors.bg2
                        radius: 4
                        visible: osdRoot.showProgressBar

                        Rectangle {
                            width: parent.width * (osdRoot.value / 100)
                            height: parent.height
                            color: Colors.accent
                            radius: 4
                        }
                    }
                }
            }

            Timer {
                id: hideTimer
                interval: 2000
                onTriggered: osdWindow.visible = false
            }
        }
    }
}
