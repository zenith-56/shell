// Entry point for the Quickshell Wayland shell.
// Instantiates global config, status bar, and top-level popups.
import Quickshell
import QtQuick
import "Commons"
import "services"
import "modules/bar"
import "modules/launcher/launcher"
import "modules/bar/battery"
import "modules/bar/bluetooth"
import "modules/bar/network"

Scope {
    id: root

    LauncherPopup { }
    BatteryPopup { }
    BluetoothPopup { }
    NetworkPopup { }
    Bar { }
}
