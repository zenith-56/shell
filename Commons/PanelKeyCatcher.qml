// Keyboard dispatcher for shell panels.
// Instantiate inside a popup to get vim-style navigation.
// The popup must implement: close(), nextField(), prevField(),
// moveDown(), moveUp(), moveLeft(), moveRight(), activate().
import QtQuick

QtObject {
    id: root

    property Item target: null

    function handleKey(event) {
        if (!target) return false
        const k = event.key
        const t = event.text

        if (k === Qt.Key_Escape) {
            target.close(); return true
        }
        if (k === Qt.Key_Tab) {
            target.nextField(); return true
        }
        if (k === Qt.Key_Backtab) {
            target.prevField(); return true
        }
        if (t === "j" || k === Qt.Key_Down) {
            target.moveDown(); return true
        }
        if (t === "k" || k === Qt.Key_Up) {
            target.moveUp(); return true
        }
        if (t === "h" || k === Qt.Key_Left) {
            target.moveLeft(); return true
        }
        if (t === "l" || k === Qt.Key_Right) {
            target.moveRight(); return true
        }
        if (k === Qt.Key_Return || k === Qt.Key_Enter || k === Qt.Key_Space) {
            target.activate(); return true
        }
        return false
    }
}
