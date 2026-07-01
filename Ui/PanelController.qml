// State machine for managing popup open/close.
// Pure state logic — no UI, no rendering.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property string activePopupId: ""

    function isOpen(popupId) {
        return activePopupId === popupId
    }

    function show(popupId) {
        activePopupId = popupId
    }

    function hide(popupId) {
        if (activePopupId === popupId) {
            activePopupId = ""
        }
    }

    function closeAll() {
        activePopupId = ""
    }

    function toggle(popupId) {
        if (activePopupId === popupId) {
            activePopupId = ""
        } else {
            activePopupId = popupId
        }
    }
}
