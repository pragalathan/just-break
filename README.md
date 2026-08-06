# JustBreak

A small Qt 6 QML break reminder for KDE Plasma (Wayland).

It stays in the system tray and, every **14 minutes 30 seconds**, shows a frameless **30-second** countdown overlay. The overlay is not listed in the task manager.

## Features

- Hidden at startup; first reminder after 14:30
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

```bash
make
./bin/JustBreak
```

Or:

```bash
make run
```

CMake (optional):

```bash
cmake -S . -B build
cmake --build build
```

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
└── bin/              # Build output (binary, QML, icons)
```

## Notes

- Designed for **KDE Plasma on Wayland**. LayerShell is what keeps the overlay out of the task manager.
- The process stays running while the overlay is hidden (`QuitOnLastWindowClosed` is off). Quit by ending the process (or add a Quit tray item if you want one).

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
