// Lock screen plugin — triggers session lock.
// Uses loginctl lock-session to lock the screen.
// Can be triggered via keyboard shortcut or bar button.
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool locked: false

    function lock() {
        lockProc.running = false
        lockProc.running = true
        locked = true
    }

    function unlock() {
        locked = false
    }

    Process {
        id: lockProc
        running: false
        command: ["loginctl", "lock-session"]
    }
}
