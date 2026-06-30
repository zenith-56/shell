// Popup control singleton.
// Mediates between bar indicators and top-level PanelWindow popups.
// Stores the anchor position so popups appear below their trigger icon.
pragma Singleton
import Quickshell
import QtQuick

QtObject {
    property string activePopup: ""
    property real anchorX: 0
    property real anchorWidth: 0
    property real barHeight: 32

    function open(name, triggerItem) {
        if (triggerItem) updateAnchor(triggerItem)
        activePopup = name
    }

    function close() {
        activePopup = ""
    }

    function toggle(name, triggerItem) {
        if (activePopup === name) {
            activePopup = ""
        } else {
            if (triggerItem) updateAnchor(triggerItem)
            activePopup = name
        }
    }

    function isOpen(name) {
        return activePopup === name
    }

    function updateAnchor(item) {
        var window = item.Window.window
        if (!window) return
        var pos = item.mapToItem(window.contentItem, 0, 0)
        anchorX = pos.x
        anchorWidth = item.width
    }
}
