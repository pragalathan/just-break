# JustBreak

Sitting is the new diabetes. JustBreak nudges developers and managers who stare at the screen for long stretches to get up, stay healthy, and stay physically active — so they can avoid muscle strain and eye strain.

A small Qt 6 QML break reminder for KDE Plasma (Wayland).

It stays in the system tray and, every **14 minutes 30 seconds**, shows a frameless **30-second** countdown overlay. The overlay is not listed in the task manager.

## Features

- Hidden at startup; first reminder after 14:30 (`--test` shows it immediately)
- Centered 200×80 overlay with a 30s countdown
- System tray icon with Pause / Resume / Cancel
- Paused tray icon (`tux_sleep_paused.png`) when scheduling is suspended
- Uses KDE LayerShell so the overlay stays off the taskbar

## Requirements

- Qt 6 (Core, Gui, Widgets, Qml, Quick)
- `qml6-module-qt-labs-platform` (system tray)
- `qml6-module-org-kde-layershell` (KDE overlay / no taskbar entry)
- C++17 compiler and `make` (or CMake)

On Ubuntu / Debian:

```bash
sudo apt install g++ qt6-base-dev qt6-declarative-dev \
  qml6-module-qt-labs-platform qml6-module-org-kde-layershell
```

## Build & run

### Development (quick)

Copies `Main.qml` and `icons/` next to the binary so you can edit QML without rebuilding:

```bash
make
./bin/JustBreak
```

Or:

```bash
make run
```

Show the countdown immediately (skip the first 14:30 wait):

```bash
./bin/JustBreak --test
```

### Production (standalone binary)

Embeds `Main.qml` and tray icons into the executable — no sidecar QML or icon files needed:

```bash
make release-local
./build-release/JustBreak
```

Or with CMake (requires `qt6-declarative-dev`):

```bash
make release
./build-release/JustBreak
```

Optional install to a `dist/` folder:

```bash
make install
./dist/bin/JustBreak
```

You can copy **only** `build-release/JustBreak` to another machine; it does not need `Main.qml` or `icons/` beside it.

**Note:** The binary still needs Qt 6 and these QML plugins on the target system (they cannot be fully static-linked easily):

- `qml6-module-qt-labs-platform` (system tray)
- `qml6-module-org-kde-layershell` (KDE overlay)

Only your app’s QML and PNG icons are baked into the binary.

## Tray menu

| Action | Behavior |
|--------|----------|
| **Pause** | Suspends the next reminder. Enabled only when not already paused. |
| **Resume** | Schedules the next reminder 14:30 from now. Enabled only when paused. |
| **Cancel** | Stops and hides the countdown if it is currently shown. |

## Timing

| Setting | Value |
|---------|-------|
| Countdown | 30 seconds |
| Interval between reminders | 14 minutes 30 seconds |

Edit `countdownSeconds` and `repeatIntervalMs` in `Main.qml` to change these.

## Project layout

```
JustBreak/
├── main.cpp          # Qt application host (QApplication + QML)
├── Main.qml          # Overlay UI, timers, tray menu
├── icons/
│   ├── tux_sleep.png
│   └── tux_sleep_paused.png
├── Makefile
├── CMakeLists.txt
├── resources.qrc     # QML + icons for production build
├── bin/              # Dev build output (binary + sidecar QML/icons)
└── build-release/    # Production build (single binary)
```

## Notes

- Designed for **KDE Plasma on Wayland**. LayerShell is what keeps the overlay out of the task manager.
- The process stays running while the overlay is hidden (`QuitOnLastWindowClosed` is off). Quit by ending the process (or add a Quit tray item if you want one).

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
