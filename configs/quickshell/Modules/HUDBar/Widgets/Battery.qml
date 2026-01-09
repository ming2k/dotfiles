import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../../Common"

RowLayout {
    spacing: 6
    visible: hasBattery

    property int batteryPercent: 0
    property bool isCharging: false
    property bool hasBattery: false

    Icon {
        id: batteryIcon
        size: 16
        Layout.alignment: Qt.AlignVCenter
        iconColor: battText.color

        name: {
            if (!hasBattery) return ""

            // Round battery percentage to nearest 10
            let roundedPercent = Math.floor(batteryPercent / 10) * 10
            if (roundedPercent > 100) roundedPercent = 100

            // Format as 3-digit string (e.g., 050, 080, 100)
            let percentStr = roundedPercent.toString().padStart(3, '0')

            if (isCharging) {
                return `battery-${percentStr}-charging`
            } else {
                return `battery-${percentStr}`
            }
        }
    }

    Text {
        id: battText
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: 13
        font.family: "Cantarell"

        text: `${batteryPercent}%`

        color: {
            if (!hasBattery) return Colors.fg1
            if (batteryPercent <= 15 && !isCharging) return Colors.red
            if (batteryPercent <= 30 && !isCharging) return Colors.orange
            return Colors.fg1
        }
    }

    Process {
        id: batteryChecker
        running: true
        command: ["sh", "-c", `
            # Find battery
            bat=$(ls /sys/class/power_supply/ | grep -i 'BAT' | head -1)
            if [ -z "$bat" ]; then
                echo "NONE"
                exit 0
            fi

            # Read battery info
            capacity=$(cat /sys/class/power_supply/$bat/capacity 2>/dev/null || echo "0")
            status=$(cat /sys/class/power_supply/$bat/status 2>/dev/null || echo "Unknown")

            echo "$capacity|$status"
        `]

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim()
                if (output === "NONE") {
                    hasBattery = false
                    return
                }

                let parts = output.split("|")
                if (parts.length === 2) {
                    hasBattery = true
                    batteryPercent = parseInt(parts[0]) || 0
                    isCharging = parts[1].toLowerCase().includes("charg")
                }
            }
        }
    }

    Timer {
        interval: 10000  // Update every 10 seconds
        running: true
        repeat: true
        onTriggered: batteryChecker.running = true
    }
}
