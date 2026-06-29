// Entry point for the Quickshell Wayland shell.
// Instantiates global config and the status bar.
import Quickshell
import QtQuick
import "Commons"
import "services"
import "modules/bar"

Scope {
    id: root

    Bar { }
}