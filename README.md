# Shell

Modular Wayland status bar built with [Quickshell](https://quickshell.org) for Niri compositor.

## Project Structure

```
shell.qml                  # Entry point
Commons/                   # Shared singletons (qs.Commons module)
  Color.qml                # Global color palette
  Style.qml                # Spacing, typography, bar dimensions
  Util.qml                 # Utility functions
  BarConfig.qml            # Bar appearance settings
  Config.qml               # JSON config loader (reads shell.json)
services/                  # System integration singletons
  Battery.qml              # UPower battery monitoring
  Network.qml              # NetworkManager/WiFi status (nmcli)
  Audio.qml                # PipeWire volume control (wpctl)
  Time.qml                 # Clock with 12/24hr support
  Workspaces.qml           # Niri workspace tracking
modules/                   # UI feature modules
  bar/                     # Status bar components
    Bar.qml                # Main bar container (PanelWindow)
    Clock.qml              # Time display with toggle
    BatteryIndicator.qml   # Battery icon + popup
    NetworkIndicator.qml   # Network icon + SSID
    AudioIndicator.qml     # Volume icon + mute toggle
    Workspaces.qml         # Workspace indicators
    battery/               # Battery popup sub-module
      BatteryPopup.qml     # Detailed battery info popup
      BatteryInfo.qml      # Icon, percentage, status
      BatteryWatts.qml     # Power consumption
      BatteryHealth.qml    # Health, capacity, model
utils/                     # Shared helpers
  Paths.qml                # Filesystem path constants
  Icons.qml                # Icon theme resolver
```

## Install

```bash
ln -sf ~/projects/shell ~/.config/quickshell
```

## Run

```bash
quickshell -c ~/projects/shell
```

## Services

- **Battery** — UPower battery monitoring with charge-level icons
- **Network** — NetworkManager/WiFi status via nmcli (polls every 10s)
- **Audio** — PipeWire volume control via wpctl (polls every 1s)
- **Time** — Live clock with 12/24hr format support
- **Workspaces** — Dynamic Niri workspace tracking

## Configuration

Edit `shell.json` to customize bar appearance and enabled modules. Changes hot-reload automatically.

## Dependencies

- [quickshell](https://quickshell.org) (v0.1.0+)
- upower (battery service)
- networkmanager (network service)
- pipewire + wireplumber (audio service)
- niri (compositor)

## Conventions

See [AGENTS.md](AGENTS.md) for coding conventions and architecture rules.
