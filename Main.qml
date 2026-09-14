// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Pragalathan M

import QtQuick
import QtQuick.Window
import Qt.labs.platform as Platform
import org.kde.layershell as LayerShell

Window {
    id: root

    readonly property int countdownSeconds: 30
    readonly property int repeatIntervalMs: (14 * 60 + 30) * 1000

    property int remaining: countdownSeconds
    property bool paused: false

    width: 620
    height: 205

    visible: false
    color: "transparent"

    title: "JustBreak"

    flags:
        Qt.FramelessWindowHint
        | Qt.WindowStaysOnTopHint
        | Qt.WindowDoesNotAcceptFocus
        | Qt.NoDropShadowWindowHint


    // ============================================================
    // KDE LAYERSHELL
    // ============================================================

    LayerShell.Window.scope:
        "justbreak"

    LayerShell.Window.layer:
        LayerShell.Window.LayerOverlay

    LayerShell.Window.exclusionZone:
        -1

    LayerShell.Window.keyboardInteractivity:
        LayerShell.Window.KeyboardInteractivityNone

    LayerShell.Window.activateOnShow:
        false

    LayerShell.Window.anchors:
        LayerShell.Window.AnchorTop


    // ============================================================
    // TIMER FUNCTIONS
    // ============================================================

    function formatTime(secs) {

        const m = Math.floor(secs / 60)
        const s = secs % 60

        return String(m).padStart(2, "0")
             + ":"
             + String(s).padStart(2, "0")
    }


    function centerOnScreen() {

        const screen =
            Qt.application.screens[0]

        if (!screen)
            return

        width = Math.min(
            450,
            Math.max(
                350,
                Math.round(screen.width * 0.2)
            )
        )

        height =
            Math.round(width * 0.45)

        const side =
            Math.max(
                0,
                Math.round(
                    (screen.width - width) / 2
                )
            )

        const top =
            Math.max(
                0,
                Math.round(
                    (screen.height - height) / 2
                )
            )

        LayerShell.Window.margins = ({
            left: side,
            top: top,
            right: side,
            bottom: 0
        })
    }


    function scheduleNext() {

        if (root.paused)
            return

        resumeTimer.restart()
    }


    function startCountdown() {

        if (root.paused)
            return

        remaining =
            countdownSeconds

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

        remaining =
            countdownSeconds

        root.scheduleNext()
    }


    // ============================================================
    // FONTS
    // ============================================================

    FontLoader {
        id: smoochSans

        source:
            Qt.resolvedUrl("fonts/SmoochSans-SemiBold.ttf")
    }

    FontLoader {
        id: abel

        source:
            Qt.resolvedUrl("fonts/Abel-Regular.ttf")
    }


    // ============================================================
    // PLAQUE
    // ============================================================

    Item {
        id: plaque

        anchors.fill: parent

        readonly property real outerMargin:
            Math.max(
                5,
                Math.round(height * 0.028)
            )

        readonly property real x0:
            outerMargin

        readonly property real y0:
            outerMargin

        readonly property real w:
            width - outerMargin * 2

        readonly property real h:
            height - outerMargin * 2

        readonly property real radius:
            Math.max(
                10,
                Math.round(height * 0.095)
            )


        // ========================================================
        // DROP SHADOW
        // ========================================================

        Canvas {
            id: plaqueShadow

            anchors.fill: parent

            antialiasing: true


            function roundedRect(
                ctx,
                x,
                y,
                w,
                h,
                r
            ) {

                r = Math.min(
                    r,
                    w / 2,
                    h / 2
                )

                ctx.beginPath()

                ctx.moveTo(
                    x + r,
                    y
                )

                ctx.lineTo(
                    x + w - r,
                    y
                )

                ctx.quadraticCurveTo(
                    x + w,
                    y,
                    x + w,
                    y + r
                )

                ctx.lineTo(
                    x + w,
                    y + h - r
                )

                ctx.quadraticCurveTo(
                    x + w,
                    y + h,
                    x + w - r,
                    y + h
                )

                ctx.lineTo(
                    x + r,
                    y + h
                )

                ctx.quadraticCurveTo(
                    x,
                    y + h,
                    x,
                    y + h - r
                )

                ctx.lineTo(
                    x,
                    y + r
                )

                ctx.quadraticCurveTo(
                    x,
                    y,
                    x + r,
                    y
                )

                ctx.closePath()
            }


            onPaint: {

                const ctx =
                    getContext("2d")

                ctx.reset()

                roundedRect(
                    ctx,
                    plaque.x0 + 1,
                    plaque.y0 + 4,
                    plaque.w,
                    plaque.h,
                    plaque.radius
                )

                ctx.fillStyle =
                    Qt.rgba(
                        0,
                        0,
                        0,
                        0.26
                    )

                ctx.fill()
            }


            onWidthChanged:
                requestPaint()

            onHeightChanged:
                requestPaint()

            Component.onCompleted:
                requestPaint()
        }


        // ========================================================
        // METAL
        // ========================================================

        Canvas {
            id: metal

            anchors.fill: parent

            antialiasing: true


            // ====================================================
            // ROUNDED RECTANGLE
            // ====================================================

            function roundedRect(
                ctx,
                x,
                y,
                w,
                h,
                r
            ) {

                r = Math.min(
                    r,
                    w / 2,
                    h / 2
                )

                ctx.beginPath()

                ctx.moveTo(
                    x + r,
                    y
                )

                ctx.lineTo(
                    x + w - r,
                    y
                )

                ctx.quadraticCurveTo(
                    x + w,
                    y,
                    x + w,
                    y + r
                )

                ctx.lineTo(
                    x + w,
                    y + h - r
                )

                ctx.quadraticCurveTo(
                    x + w,
                    y + h,
                    x + w - r,
                    y + h
                )

                ctx.lineTo(
                    x + r,
                    y + h
                )

                ctx.quadraticCurveTo(
                    x,
                    y + h,
                    x,
                    y + h - r
                )

                ctx.lineTo(
                    x,
                    y + r
                )

                ctx.quadraticCurveTo(
                    x,
                    y,
                    x + r,
                    y
                )

                ctx.closePath()
            }


            function random(seed) {

                const n =
                    Math.sin(
                        seed * 12.9898
                        + 78.233
                    )
                    * 43758.5453123

                return n -
                       Math.floor(n)
            }


            // ====================================================
            // METAL SURFACE
            // ====================================================

            function paintMetal(
                ctx,
                x,
                y,
                w,
                h
            ) {

                // ------------------------------------------------
                // Base aluminium
                // ------------------------------------------------

                const base =
                    ctx.createLinearGradient(
                        x,
                        y,
                        x + w,
                        y
                    )

                base.addColorStop(
                    0.00,
                    "#f0f1f1"
                )

                base.addColorStop(
                    0.10,
                    "#eceeee"
                )

                base.addColorStop(
                    0.23,
                    "#e5e7e7"
                )

                base.addColorStop(
                    0.38,
                    "#dcdedf"
                )

                base.addColorStop(
                    0.52,
                    "#ced0d1"
                )

                base.addColorStop(
                    0.66,
                    "#babdbf"
                )

                base.addColorStop(
                    0.78,
                    "#a5a9ab"
                )

                base.addColorStop(
                    0.90,
                    "#94989b"
                )

                base.addColorStop(
                    1.00,
                    "#858a8d"
                )

                ctx.fillStyle =
                    base

                ctx.fillRect(
                    x,
                    y,
                    w,
                    h
                )


                // =================================================
                // FINE BRUSH GRAIN
                // =================================================

                for (
                    let row = 0;
                    row < h;
                    ++row
                ) {

                    const n1 =
                        random(
                            row * 4.731
                            + 17
                        )

                    const n2 =
                        random(
                            row * 17.17
                            + 91
                        )

                    const wave =
                        Math.sin(
                            row * 7.91
                        ) * 0.42
                        +
                        Math.sin(
                            row * 2.17
                            + n1 * 2.0
                        ) * 0.22
                        +
                        (n2 - 0.5) * 0.36


                    const visibility =
                        0.20
                        +
                        n1 * 0.80


                    if (
                        Math.abs(wave) < 0.13
                        && n2 < 0.65
                    ) {
                        continue
                    }


                    const alpha =
                        (
                            0.018
                            +
                            Math.abs(wave)
                            * 0.050
                        )
                        *
                        visibility


                    if (wave > 0) {

                        ctx.fillStyle =
                            Qt.rgba(
                                1,
                                1,
                                1,
                                alpha
                            )

                    } else {

                        ctx.fillStyle =
                            Qt.rgba(
                                40 / 255,
                                43 / 255,
                                45 / 255,
                                alpha
                            )
                    }


                    ctx.fillRect(
                        x,
                        y + row,
                        w,
                        1
                    )
                }


                // =================================================
                // LONG IRREGULAR STREAKS
                // =================================================

                for (
                    let i = 0;
                    i < Math.round(h * 0.55);
                    ++i
                ) {

                    const n =
                        random(
                            i * 19.731
                            + 111
                        )

                    const row =
                        Math.floor(
                            n * h
                        )

                    const startN =
                        random(
                            i * 43.71
                            + 7
                        )

                    const lengthN =
                        random(
                            i * 71.31
                            + 19
                        )

                    const start =
                        x
                        +
                        startN
                        * w
                        * 0.90

                    const length =
                        w
                        *
                        (
                            0.08
                            +
                            lengthN * 0.48
                        )


                    if (n > 0.48) {

                        ctx.fillStyle =
                            Qt.rgba(
                                1,
                                1,
                                1,
                                0.025
                                + lengthN * 0.025
                            )

                    } else {

                        ctx.fillStyle =
                            Qt.rgba(
                                45 / 255,
                                48 / 255,
                                50 / 255,
                                0.018
                                + lengthN * 0.020
                            )
                    }


                    ctx.fillRect(
                        start,
                        y + row,
                        length,
                        1
                    )
                }


                // =================================================
                // VERY FINE MACHINE MARKS
                // =================================================

                for (
                    let row = 0;
                    row < h;
                    row += 5
                ) {

                    const n =
                        random(
                            row * 83.17
                            + 203
                        )

                    if (n < 0.45)
                        continue


                    ctx.fillStyle =
                        Qt.rgba(
                            1,
                            1,
                            1,
                            0.018
                            + n * 0.018
                        )

                    ctx.fillRect(
                        x,
                        y + row,
                        w,
                        1
                    )
                }


                // =================================================
                // DIRECTIONAL LIGHT
                // =================================================

                const light =
                    ctx.createLinearGradient(
                        x,
                        y,
                        x + w,
                        y + h
                    )

                light.addColorStop(
                    0.00,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.24
                    )
                )

                light.addColorStop(
                    0.14,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.14
                    )
                )

                light.addColorStop(
                    0.32,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.045
                    )
                )

                light.addColorStop(
                    0.50,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0
                    )
                )

                light.addColorStop(
                    0.68,
                    Qt.rgba(
                        35 / 255,
                        38 / 255,
                        40 / 255,
                        0.06
                    )
                )

                light.addColorStop(
                    0.82,
                    Qt.rgba(
                        30 / 255,
                        33 / 255,
                        35 / 255,
                        0.12
                    )
                )

                light.addColorStop(
                    0.94,
                    Qt.rgba(
                        20 / 255,
                        23 / 255,
                        25 / 255,
                        0.19
                    )
                )

                light.addColorStop(
                    1.00,
                    Qt.rgba(
                        15 / 255,
                        18 / 255,
                        20 / 255,
                        0.25
                    )
                )

                ctx.fillStyle =
                    light

                ctx.fillRect(
                    x,
                    y,
                    w,
                    h
                )


                // =================================================
                // SOFT REFLECTION
                // =================================================

                const reflection =
                    ctx.createLinearGradient(
                        x,
                        y,
                        x,
                        y + h
                    )

                reflection.addColorStop(
                    0.00,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.07
                    )
                )

                reflection.addColorStop(
                    0.22,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.025
                    )
                )

                reflection.addColorStop(
                    0.46,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.00
                    )
                )

                reflection.addColorStop(
                    0.70,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.035
                    )
                )

                reflection.addColorStop(
                    1.00,
                    Qt.rgba(
                        0,
                        0,
                        0,
                        0.035
                    )
                )

                ctx.fillStyle =
                    reflection

                ctx.fillRect(
                    x,
                    y,
                    w,
                    h
                )


                // =================================================
                // SOFT TOP-LEFT LIGHT
                // =================================================

                const lightPool =
                    ctx.createRadialGradient(
                        x + w * 0.13,
                        y + h * 0.18,
                        0,

                        x + w * 0.13,
                        y + h * 0.18,
                        w * 0.68
                    )

                lightPool.addColorStop(
                    0.00,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.16
                    )
                )

                lightPool.addColorStop(
                    0.25,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.07
                    )
                )

                lightPool.addColorStop(
                    0.55,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.018
                    )
                )

                lightPool.addColorStop(
                    1.00,
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0
                    )
                )

                ctx.fillStyle =
                    lightPool

                ctx.fillRect(
                    x,
                    y,
                    w,
                    h
                )
            }


            // ====================================================
            // BORDER
            // ====================================================

            function paintBorder(
                ctx,
                x,
                y,
                w,
                h,
                r
            ) {

                // Outer dark edge
                roundedRect(
                    ctx,
                    x + 0.6,
                    y + 1.7,
                    w - 1.2,
                    h - 1.1,
                    r
                )

                ctx.strokeStyle =
                    Qt.rgba(
                        35 / 255,
                        38 / 255,
                        40 / 255,
                        0.78
                    )

                ctx.lineWidth =
                    1.45

                ctx.stroke()


                // Bright rim
                roundedRect(
                    ctx,
                    x + 1.0,
                    y + 0.7,
                    w - 2,
                    h - 1.7,
                    Math.max(
                        1,
                        r - 0.5
                    )
                )

                ctx.strokeStyle =
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.90
                    )

                ctx.lineWidth =
                    1.15

                ctx.stroke()


                // Inner darker edge
                roundedRect(
                    ctx,
                    x + 2.5,
                    y + 2.7,
                    w - 5,
                    h - 4.7,
                    Math.max(
                        1,
                        r - 1.4
                    )
                )

                ctx.strokeStyle =
                    Qt.rgba(
                        55 / 255,
                        58 / 255,
                        60 / 255,
                        0.52
                    )

                ctx.lineWidth =
                    1

                ctx.stroke()


                // Inner highlight
                roundedRect(
                    ctx,
                    x + 3.3,
                    y + 2.1,
                    w - 6.6,
                    h - 4.2,
                    Math.max(
                        1,
                        r - 2
                    )
                )

                ctx.strokeStyle =
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.22
                    )

                ctx.lineWidth =
                    1

                ctx.stroke()
            }


            // ====================================================
            // RIVET
            // ====================================================

            function drawRivet(
                ctx,
                cx,
                cy,
                r
            ) {

                // Contact shadow
                ctx.beginPath()

                ctx.arc(
                    cx + r * 0.14,
                    cy + r * 0.20,
                    r + 1.6,
                    0,
                    Math.PI * 2
                )

                ctx.fillStyle =
                    Qt.rgba(
                        0,
                        0,
                        0,
                        0.30
                    )

                ctx.fill()


                // Outer mounting rim
                ctx.beginPath()

                ctx.arc(
                    cx,
                    cy,
                    r + 0.8,
                    0,
                    Math.PI * 2
                )

                ctx.fillStyle =
                    "#4b5053"

                ctx.fill()


                // Dome
                const dome =
                    ctx.createRadialGradient(
                        cx - r * 0.40,
                        cy - r * 0.43,
                        r * 0.03,

                        cx + r * 0.20,
                        cy + r * 0.25,
                        r * 1.12
                    )

                dome.addColorStop(
                    0.00,
                    "#ffffff"
                )

                dome.addColorStop(
                    0.12,
                    "#f8f9f9"
                )

                dome.addColorStop(
                    0.28,
                    "#dfe2e3"
                )

                dome.addColorStop(
                    0.46,
                    "#bcc0c2"
                )

                dome.addColorStop(
                    0.66,
                    "#898e91"
                )

                dome.addColorStop(
                    0.84,
                    "#565c5f"
                )

                dome.addColorStop(
                    1.00,
                    "#303538"
                )

                ctx.beginPath()

                ctx.arc(
                    cx,
                    cy,
                    r,
                    0,
                    Math.PI * 2
                )

                ctx.fillStyle =
                    dome

                ctx.fill()


                // Highlight
                ctx.beginPath()

                ctx.arc(
                    cx - r * 0.34,
                    cy - r * 0.35,
                    r * 0.17,
                    0,
                    Math.PI * 2
                )

                ctx.fillStyle =
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.82
                    )

                ctx.fill()
            }


            function drawRivets(
                ctx,
                x,
                y,
                w,
                h
            ) {

                const r =
                    Math.max(
                        6,
                        Math.min(
                            10,
                            h * 0.065
                        )
                    )

                const inset =
                    Math.max(
                        22,
                        h * 0.17
                    )

                drawRivet(
                    ctx,
                    x + inset,
                    y + inset,
                    r
                )

                drawRivet(
                    ctx,
                    x + w - inset,
                    y + inset,
                    r
                )

                drawRivet(
                    ctx,
                    x + inset,
                    y + h - inset,
                    r
                )

                drawRivet(
                    ctx,
                    x + w - inset,
                    y + h - inset,
                    r
                )
            }


            // ====================================================
            // PAINT
            // ====================================================

            onPaint: {

                const ctx =
                    getContext("2d")

                ctx.reset()

                const x =
                    plaque.x0

                const y =
                    plaque.y0

                const w =
                    plaque.w

                const h =
                    plaque.h

                const r =
                    plaque.radius

                if (
                    w < 10
                    || h < 10
                )
                    return


                roundedRect(
                    ctx,
                    x,
                    y,
                    w,
                    h,
                    r
                )

                ctx.save()

                ctx.clip()

                paintMetal(
                    ctx,
                    x,
                    y,
                    w,
                    h
                )

                ctx.restore()


                paintBorder(
                    ctx,
                    x,
                    y,
                    w,
                    h,
                    r
                )


                drawRivets(
                    ctx,
                    x,
                    y,
                    w,
                    h
                )
            }


            onWidthChanged:
                requestPaint()

            onHeightChanged:
                requestPaint()

            Component.onCompleted:
                requestPaint()
        }


        // ========================================================
        // TEXT
        // ========================================================

        Item {
            id: lettering

            anchors.fill: parent


            // ====================================================
            // TIMER
            // ====================================================

            Item {
                id: timerText

                anchors.horizontalCenter:
                    parent.horizontalCenter

                anchors.top:
                    parent.top

                anchors.topMargin:
                    parent.height * 0.085

                // -------------------------------------------------
                // Fixed-slot layout
                // -------------------------------------------------
                //
                // Smooch Sans is proportional — digits like "1" and
                // "4" have very different advance widths. Centering
                // the whole "MM:SS" string by its own implicit width
                // made every character visibly slide left/right as
                // the seconds ticked over.
                //
                // Instead, each character gets its own FIXED-width
                // slot (digit slots are all the same width no
                // matter which digit is inside; the colon gets its
                // own narrower fixed slot). The row's total width
                // is therefore constant every single tick, so
                // nothing drifts.

                readonly property string timeString:
                    root.formatTime(
                        root.remaining
                    )

                readonly property real digitPixelSize:
                    Math.max(
                        72,
                        Math.round(
                            parent.height * 0.62
                        )
                    )

                // Widest digit in the font is ~0.444em. Keep slots
                // just above that so digits stay tabular without
                // extra gaps.
                readonly property real digitSlotWidth:
                    digitPixelSize * 0.46

                readonly property real colonSlotWidth:
                    digitPixelSize * 0.22

                readonly property real slotHeight:
                    digitPixelSize * 1.15

                // Embossed rim (raised letter, not a cut):
                //   white on the right outer edge
                //   black on the left inner edge
                // White offset is slightly larger so it reads as the
                // outer lip; black is tighter so it peeks as an
                // inner wall. Must use *Offset — Qt ignores x/y
                // when centerIn is set.
                readonly property real outerRim:
                    Math.max(1.4, digitPixelSize * 0.012)

                readonly property real innerRim:
                    Math.max(1.4, digitPixelSize * 0.012)

                readonly property color floorColor:
                    root.remaining <= 5
                    ? "#1e4491" //1235a6 //df0942 // Qt.rgba(92 / 255, 43 / 255, 38 / 255, 0.70)
                    : "#505050"
                width:
                    row.width

                height:
                    slotHeight

                Row {
                    id: row

                    anchors.centerIn:
                        parent

                    spacing:
                        0

                    Repeater {
                        model:
                            timerText.timeString.length

                        Item {
                            id: slot

                            readonly property string digitChar:
                                timerText.timeString[index]

                            width:
                                digitChar === ":"
                                ? timerText.colonSlotWidth
                                : timerText.digitSlotWidth

                            height:
                                timerText.slotHeight

                            // Smooch Sans colon sits ~0.10em below the
                            // digit optical center; lift it so ":"
                            // lines up with 00 / 30.
                            readonly property real verticalNudge:
                                digitChar === ":"
                                ? -(timerText.digitPixelSize * 0.10)
                                : 0

                            // White lining — right outer edge
                            Text {
                                anchors.centerIn:
                                    parent

                                anchors.horizontalCenterOffset:
                                    timerText.outerRim

                                anchors.verticalCenterOffset:
                                    timerText.outerRim * 0.35
                                    + slot.verticalNudge

                                text:
                                    slot.digitChar

                                font.family:
                                    smoochSans.name

                                font.pixelSize:
                                    timerText.digitPixelSize

                                font.weight:
                                    600

                                color:
                                    "#ffffff"
                            }

                            // Black lining — left inner edge
                            Text {
                                anchors.centerIn:
                                    parent

                                anchors.horizontalCenterOffset:
                                    -timerText.innerRim

                                anchors.verticalCenterOffset:
                                    -timerText.innerRim * 0.25
                                    + slot.verticalNudge

                                text:
                                    slot.digitChar

                                font.family:
                                    smoochSans.name

                                font.pixelSize:
                                    timerText.digitPixelSize

                                font.weight:
                                    600

                                color:
                                    "#000000"
                            }

                            // Semi-transparent face so metal shows through
                            Text {
                                anchors.centerIn:
                                    parent

                                anchors.verticalCenterOffset:
                                    slot.verticalNudge

                                text:
                                    slot.digitChar

                                font.family:
                                    smoochSans.name

                                font.pixelSize:
                                    timerText.digitPixelSize

                                font.weight:
                                    600

                                color:
                                    timerText.floorColor
                            }
                        }
                    }
                }
            }


            // ====================================================
            // ENOUGH OF WORK
            // ====================================================

            Item {
                id: breakMessage

                anchors.horizontalCenter:
                    parent.horizontalCenter

                anchors.top:
                    timerText.bottom

                anchors.topMargin:
                    -2

                readonly property string message:
                    "enough of work"

                readonly property real messageSize:
                    Math.max(
                        12,
                        Math.round(
                            parent.height * 0.105
                        )
                    )

                readonly property real messageRim:
                    Math.max(0.6, messageSize * 0.045)

                width:
                    messageFace.implicitWidth
                    + messageRim * 2

                height:
                    messageFace.implicitHeight
                    + messageRim * 2

                // White — right outer edge
                Text {
                    anchors.centerIn:
                        parent

                    anchors.horizontalCenterOffset:
                        breakMessage.messageRim

                    anchors.verticalCenterOffset:
                        breakMessage.messageRim * 0.35

                    text:
                        breakMessage.message

                    font.family:
                        abel.name

                    font.pixelSize:
                        breakMessage.messageSize

                    font.italic:
                        false

                    color:
                        "#f7f8f9"
                }

                // Dark grey — left inner edge
                Text {
                    anchors.centerIn:
                        parent

                    anchors.horizontalCenterOffset:
                        -breakMessage.messageRim

                    anchors.verticalCenterOffset:
                        -breakMessage.messageRim * 0.25

                    text:
                        breakMessage.message

                    font.family:
                        abel.name

                    font.pixelSize:
                        breakMessage.messageSize

                    font.italic:
                        false

                    color:
                        "#4a4e52"
                }

                Text {
                    id: messageFace

                    anchors.centerIn:
                        parent

                    text:
                        breakMessage.message

                    font.family:
                        abel.name

                    font.pixelSize:
                        breakMessage.messageSize

                    font.italic:
                        false

                    color:
                        Qt.rgba(
                            72 / 255,
                            76 / 255,
                            80 / 255,
                            0.72
                        )
                }
            }
        }
    }


    // ============================================================
    // COUNTDOWN
    // ============================================================

    Timer {
        id: tick

        interval:
            1000

        repeat:
            true

        running:
            false

        onTriggered: {

            if (root.remaining > 0)
                root.remaining -= 1

            if (root.remaining === 0)
                root.onCountdownFinished()
        }
    }


    // ============================================================
    // NEXT BREAK
    // ============================================================

    Timer {
        id: resumeTimer

        interval:
            root.repeatIntervalMs

        repeat:
            false

        running:
            !testMode

        onTriggered:
            root.startCountdown()
    }


    // ============================================================
    // SYSTEM TRAY
    // ============================================================

    Platform.SystemTrayIcon {
        id: tray

        visible:
            true

        tooltip:
            root.paused
            ? "JustBreak (paused)"
            : "JustBreak"

        icon.source:
            Qt.resolvedUrl(
                root.paused
                ? "icons/tux_sleep_paused.png"
                : "icons/tux_sleep.png"
            )


        menu: Platform.Menu {

            Platform.MenuItem {
                text:
                    qsTr("Pause")

                enabled:
                    !root.paused

                onTriggered:
                    root.pauseSchedule()
            }


            Platform.MenuItem {
                text:
                    qsTr("Resume")

                enabled:
                    root.paused

                onTriggered:
                    root.resumeSchedule()
            }


            Platform.MenuItem {
                text:
                    qsTr("Cancel")

                enabled:
                    root.visible

                onTriggered:
                    root.cancelCurrentRun()
            }
        }
    }


    // ============================================================
    // STARTUP
    // ============================================================

    Component.onCompleted: {

        root.centerOnScreen()

        if (testMode)
            root.startCountdown()
    }
}