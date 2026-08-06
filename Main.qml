// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Pragalathan M

import QtQuick
import QtQuick.Window
import Qt.labs.platform as Platform
import org.kde.layershell as LayerShell

Window {
    id: root

    readonly property int countdownSeconds: 30
    // 14 minutes 30 seconds between break reminders
    readonly property int repeatIntervalMs: (14 * 60 + 30) * 1000

    property int remaining: countdownSeconds
    property bool paused: false

    width: 200
    height: 80
    visible: false
    color: "transparent"
    title: "JustBreak"

    // Frameless overlay; LayerShell keeps it out of the task manager on KDE Wayland
    flags: Qt.FramelessWindowHint
           | Qt.WindowStaysOnTopHint
           | Qt.WindowDoesNotAcceptFocus
           | Qt.NoDropShadowWindowHint

    LayerShell.Window.scope: "justbreak"
    LayerShell.Window.layer: LayerShell.Window.LayerOverlay
    LayerShell.Window.exclusionZone: -1
    LayerShell.Window.keyboardInteractivity: LayerShell.Window.KeyboardInteractivityNone
    LayerShell.Window.activateOnShow: false
    // Pin to top edge; horizontal placement via margins after we know screen size
    LayerShell.Window.anchors: LayerShell.Window.AnchorTop

    function formatTime(secs) {
        const m = Math.floor(secs / 60)
        const s = secs % 60
        return String(m).padStart(2, "0") + ":" + String(s).padStart(2, "0")
    }

    function centerOnScreen() {
        const screen = Qt.application.screens[0]
        if (!screen)
            return
        const side = Math.max(0, Math.round((screen.width - width) / 2))
        const top = Math.max(0, Math.round((screen.height - height) / 2))
        LayerShell.Window.margins = ({ left: side, top: top, right: side, bottom: 0 })
    }

    function scheduleNext() {
        if (root.paused)
            return
        resumeTimer.restart()
    }

    function startCountdown() {
        if (root.paused)
            return
        remaining = countdownSeconds
        visible = true
        tick.restart()
    }

    function onCountdownFinished() {
        tick.stop()
        visible = false
        root.scheduleNext()
    }

    function pauseSchedule() {
        if (root.paused)
            return
        root.paused = true
        resumeTimer.stop()
    }

    function resumeSchedule() {
        if (!root.paused)
            return
        root.paused = false
        resumeTimer.restart()
    }

    function cancelCurrentRun() {
        if (!root.visible)
            return
        tick.stop()
        visible = false
        remaining = countdownSeconds
        root.scheduleNext()
    }

    Rectangle {
        anchors.fill: parent
        color: "#1c1c1e"
        radius: 12
        border.color: "#3a3a3c"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: root.formatTime(root.remaining)
            color: root.remaining <= 5 ? "#ff6b6b" : "#f5f5f7"
            font.family: "monospace"
            font.pixelSize: 36
            font.bold: true
        }
    }

    Timer {
        id: tick
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            if (root.remaining > 0)
                root.remaining -= 1
            if (root.remaining === 0)
                root.onCountdownFinished()
        }
    }

    Timer {
        id: resumeTimer
        interval: root.repeatIntervalMs
        repeat: false
        running: true
        onTriggered: root.startCountdown()
    }

    Platform.SystemTrayIcon {
        id: tray
        visible: true
        tooltip: root.paused ? "JustBreak (paused)" : "JustBreak"
        icon.source: Qt.resolvedUrl(root.paused ? "icons/tux_sleep_paused.png"
                                                : "icons/tux_sleep.png")

        menu: Platform.Menu {
            Platform.MenuItem {
                text: qsTr("Pause")
                enabled: !root.paused
                onTriggered: root.pauseSchedule()
            }
            Platform.MenuItem {
                text: qsTr("Resume")
                enabled: root.paused
                onTriggered: root.resumeSchedule()
            }
            Platform.MenuItem {
                text: qsTr("Cancel")
                enabled: root.visible
                onTriggered: root.cancelCurrentRun()
            }
        }
    }

    Component.onCompleted: root.centerOnScreen()
}
