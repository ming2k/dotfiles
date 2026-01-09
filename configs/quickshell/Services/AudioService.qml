pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: audioService

    property string volumeLevel: "0"
    property bool isMuted: false
    property string iconName: "audio-volume-muted-panel"

    function updateIconName() {
        if (isMuted) {
            iconName = "audio-volume-muted-panel"
            return
        }
        let vol = parseInt(volumeLevel)
        if (vol > 66) iconName = "audio-volume-high-panel"
        else if (vol > 33) iconName = "audio-volume-medium-panel"
        else if (vol > 0) iconName = "audio-volume-low-panel"
        else iconName = "audio-volume-muted-panel"
    }

    function toggleMute() {
        muteToggleLoader.active = true
    }

    function increaseVolume() {
        let currentVol = parseInt(volumeLevel)
        if (currentVol < 100) {
            volumeAdjustLoader.volumeChange = "+2%"
            volumeAdjustLoader.active = true
        }
    }

    function decreaseVolume() {
        volumeAdjustLoader.volumeChange = "-2%"
        volumeAdjustLoader.active = true
    }

    function setVolume(percentage) {
        volumeAdjustLoader.volumeChange = percentage + "%"
        volumeAdjustLoader.active = true
    }

    // Volume monitoring process
    property var volumeChecker: Process {
        id: volumeChecker
        running: true
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1 || echo '0%'"]

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim()
                if (output.includes("MUTED")) {
                    audioService.isMuted = true
                    let match = output.match(/[\d.]+/)
                    if (match) {
                        audioService.volumeLevel = Math.round(parseFloat(match[0]) * 100).toString()
                    }
                } else {
                    audioService.isMuted = false
                    if (output.includes("Volume:")) {
                        let match = output.match(/[\d.]+/)
                        if (match) {
                            let val = parseFloat(match[0])
                            let percentage = Math.round(val * 100)
                            if (percentage > 100) {
                                volumeCapLoader.active = true
                            }
                            audioService.volumeLevel = Math.min(percentage, 100).toString()
                        }
                    } else {
                        let match = output.match(/\d+/)
                        if (match) {
                            let percentage = parseInt(match[0])
                            if (percentage > 100) {
                                volumeCapLoader.active = true
                            }
                            audioService.volumeLevel = Math.min(percentage, 100).toString()
                        }
                    }
                }
                audioService.updateIconName()
            }
        }
    }

    property var volumeCheckTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: volumeChecker.running = true
    }

    property var volumeCapLoader: Loader {
        id: volumeCapLoader
        active: false

        sourceComponent: Process {
            running: true
            command: ["sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 100% || pactl set-sink-volume @DEFAULT_SINK@ 100%"]
            onExited: {
                volumeCapLoader.active = false
                volumeChecker.running = true
            }
        }
    }

    property var muteToggleLoader: Loader {
        id: muteToggleLoader
        active: false

        sourceComponent: Process {
            running: true
            command: ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle || pactl set-sink-mute @DEFAULT_SINK@ toggle"]
            onExited: {
                muteToggleLoader.active = false
                volumeChecker.running = true
            }
        }
    }

    property var volumeAdjustLoader: Loader {
        id: volumeAdjustLoader
        active: false
        property string volumeChange: "+5%"

        sourceComponent: Process {
            running: true
            command: ["sh", "-c", `wpctl set-volume @DEFAULT_AUDIO_SINK@ ${volumeAdjustLoader.volumeChange} -l 1.0 || pactl set-sink-volume @DEFAULT_SINK@ ${volumeAdjustLoader.volumeChange}`]
            onExited: {
                volumeAdjustLoader.active = false
                volumeChecker.running = true
            }
        }
    }

    Component.onCompleted: {
        updateIconName()
    }
}
