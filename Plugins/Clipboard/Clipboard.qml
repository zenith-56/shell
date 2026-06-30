// Clipboard history plugin — stores and retrieves copied text.
// Uses wl-copy/wl-paste for Wayland clipboard access.
// Keyboard: Ctrl+Shift+V to toggle, j/k to navigate, Enter to paste, Escape to close.
import QtQuick
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Io
import "../../Commons"

PanelWindow {
    id: root

    visible: false
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.namespace: "clipboard"
    screen: BarConfig.screen
    anchors.top: true; anchors.left: true; anchors.right: true

    property var history: []
    property int maxHistory: 50
    property int currentIndex: 0
    property string lastClipboard: ""

    function toggle() {
        if (visible) hide(); else show()
    }

    function hide() {
        visible = false; currentIndex = 0
    }

    function show() {
        refreshClipboard()
        visible = true
        currentIndex = 0
    }

    function refreshClipboard() {
        pasteProc.running = false
        pasteProc.running = true
    }

    function addToHistory(text) {
        if (!text || text === lastClipboard) return
        lastClipboard = text
        // Remove duplicates
        var filtered = []
        for (var i = 0; i < history.length; i++)
            if (history[i] !== text) filtered.push(history[i])
        filtered.unshift(text)
        if (filtered.length > maxHistory) filtered.pop()
        history = filtered
    }

    function pasteItem(text) {
        copyProc.command = ["wl-copy", text]
        copyProc.running = false; copyProc.running = true
        hide()
    }

    color: "transparent"

    MouseArea { anchors.fill: parent; onClicked: root.hide() }

    Rectangle {
        width: 400; height: contentColumn.implicitHeight + 32
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 60
        color: Color.background; radius: Style.cornerRadius

        Column {
            id: contentColumn
            anchors.fill: parent; anchors.margins: 16
            spacing: 8

            Text {
                text: "Clipboard History"
                color: Color.foreground
                font.family: Style.font.family; font.pixelSize: Style.font.subtitle
            }

            Rectangle { width: parent.width; height: 1; color: Color.border }

            Repeater {
                model: root.history

                Rectangle {
                    required property string modelData
                    required property int index
                    width: contentColumn.width; height: 32
                    color: index === root.currentIndex ? Color.hover : "transparent"
                    radius: Style.cornerRadius

                    Text {
                        anchors.left: parent.left; anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8; anchors.rightMargin: 8
                        text: modelData.length > 60 ? modelData.substring(0, 60) + "..." : modelData
                        color: Color.foreground
                        font.family: Style.font.family; font.pixelSize: Style.font.body
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onPositionChanged: root.currentIndex = index
                        onClicked: root.pasteItem(modelData)
                    }
                }
            }

            Text {
                visible: root.history.length === 0
                text: "No clipboard history"
                color: Color.muted
                font.family: Style.font.family; font.pixelSize: Style.font.body
            }
        }
    }

    Keys.priority: Keys.BeforeItem
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) { root.hide(); event.accepted = true }
        else if (event.key === Qt.Key_Down || event.text === "j") {
            root.currentIndex = Math.min(root.history.length - 1, root.currentIndex + 1)
            event.accepted = true
        } else if (event.key === Qt.Key_Up || event.text === "k") {
            root.currentIndex = Math.max(0, root.currentIndex - 1)
            event.accepted = true
        } else if (event.key === Qt.Key_Return && root.history.length > 0) {
            root.pasteItem(root.history[root.currentIndex])
            event.accepted = true
        }
    }

    Process {
        id: pasteProc
        running: false
        command: ["wl-paste", "-n"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: root.addToHistory(text.trim())
        }
    }

    Process {
        id: copyProc
        running: false
        command: []
    }

    Timer {
        running: root.visible
        interval: 500; repeat: true
        onTriggered: root.refreshClipboard()
    }
}
