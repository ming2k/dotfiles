import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../../Common"

WlrLayershell {
    id: popup

    required property var notification

    layer: WlrLayershell.Overlay
    namespace: "quickshell:notification-popup"
    exclusiveZone: -1
    keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 50
    }

    implicitHeight: notifContent.implicitHeight

    color: "transparent"

    // Notification content
    Rectangle {
        id: notifContent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: 400
        implicitHeight: contentLayout.implicitHeight + 24

        color: Colors.notificationBackground
        radius: 8
        border.color: Colors.notificationBorder
        border.width: 2

        // Slide in animation
        opacity: 0
        scale: 0.95

        Component.onCompleted: {
            slideIn.start()
        }

        ParallelAnimation {
            id: slideIn
            NumberAnimation {
                target: notifContent
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: notifContent
                property: "scale"
                from: 0.95
                to: 1.0
                duration: 200
                easing.type: Easing.OutBack
            }
        }

        RowLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Icon {
                name: popup.notification.icon || popup.notification.appIcon || "dialog-information"
                size: 48
                Layout.alignment: Qt.AlignTop
                iconColor: Colors.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: popup.notification.summary || "Notification"
                        font.bold: true
                        font.pixelSize: 16
                        font.family: "Cantarell"
                        color: Colors.fg1
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Rectangle {
                        width: 28
                        height: 28
                        color: closeArea.pressed ? Colors.buttonActive : (closeArea.containsMouse ? Colors.buttonHover : "transparent")
                        radius: 4

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: Colors.gray
                            font.pixelSize: 18
                        }

                        MouseArea {
                            id: closeArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                popup.notification.tracked = false
                                popup.destroy()
                            }
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Text {
                    text: popup.notification.body
                    color: Colors.fg2
                    font.pixelSize: 14
                    font.family: "Cantarell"
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    maximumLineCount: 5
                    elide: Text.ElideRight
                    visible: text.length > 0
                }

                // Actions
                RowLayout {
                    visible: popup.notification.actions && popup.notification.actions.length > 0
                    Layout.topMargin: 6
                    spacing: 8

                    Repeater {
                        model: popup.notification.actions
                        delegate: Rectangle {
                            color: actionArea.pressed ? Colors.buttonActive : (actionArea.containsMouse ? Colors.buttonHover : Colors.buttonBackground)
                            radius: 4
                            implicitHeight: 32
                            implicitWidth: actionText.implicitWidth + 24
                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth

                            Text {
                                id: actionText
                                anchors.centerIn: parent
                                text: modelData.text
                                color: Colors.fg1
                                font.pixelSize: 13
                                font.family: "Cantarell"
                            }

                            MouseArea {
                                id: actionArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    modelData.invoke()
                                    popup.notification.tracked = false
                                    popup.destroy()
                                }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                        }
                    }
                }
            }
        }
    }

    // Auto-dismiss timer
    Timer {
        interval: 5000
        running: true
        onTriggered: {
            popup.notification.tracked = false
            popup.destroy()
        }
    }
}
