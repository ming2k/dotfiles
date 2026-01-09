import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Item {
    NotificationServer {
        id: server

        onNotification: notification => {
            console.log("Notification received:", notification.summary)

            // Create a popup window for this notification
            const component = Qt.createComponent("NotificationPopup.qml")
            if (component.status === Component.Ready) {
                const popup = component.createObject(null, {
                    notification: notification,
                    screen: Quickshell.screens[0]  // Use primary screen
                })

                // Clean up popup when notification is closed
                notification.onClosed.connect(() => {
                    popup.destroy()
                })
            } else {
                console.error("Failed to create notification popup:", component.errorString())
            }
        }
    }
}
