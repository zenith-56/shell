// Launcher state singleton.
// Mediates communication between launcher button and popup.
pragma Singleton
import QtQuick

QtObject {
    property bool isOpen: false
    property Item anchorButtonItem: null
    property Item anchorWindow: null

    function show(btn: Item, win: Item): void {
        anchorButtonItem = btn;
        anchorWindow = win;
        isOpen = true;
    }

    function hide(): void {
        isOpen = false;
    }
}
