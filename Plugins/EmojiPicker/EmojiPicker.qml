// Emoji picker plugin — searchable emoji grid.
// Opens a searchable overlay to pick and copy emojis.
// Keyboard: Ctrl+Space to toggle, j/k/h/l to navigate, Enter to copy, Escape to close.
import QtQuick
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Io
import "../../Commons"

PanelWindow {
    id: root

    visible: false
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.namespace: "emoji-picker"
    screen: BarConfig.screen
    anchors.top: true; anchors.left: true; anchors.right: true

    readonly property var emojis: [
        "😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃",
        "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "😚", "😙",
        "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🤫", "🤔",
        "🤐", "🤨", "😐", "😑", "😶", "😏", "😒", "🙄", "😬", "😮",
        "😯", "😲", "😳", "🥺", "😦", "😧", "😨", "😰", "😥", "😢",
        "😭", "😱", "😖", "😣", "😞", "😓", "😩", "😫", "🥱", "😤",
        "😡", "😠", "🤬", "😈", "👿", "💀", "☠️", "💩", "🤡", "👹",
        "👺", "👻", "👽", "👾", "🤖", "😺", "😸", "😹", "😻", "😼",
        "👍", "👎", "👏", "🙌", "🤝", "💪", "❤️", "🧡", "💛", "💚",
        "💙", "💜", "🖤", "🤍", "💔", "❣️", "💕", "💞", "💓", "💗"
    ]

    property var filtered: emojis
    property int currentIndex: 0
    readonly property int cols: 10

    function recomputeFiltered() {
        var q = searchField.text.toLowerCase()
        if (!q) { filtered = emojis; return }
        var out = []
        for (var i = 0; i < emojis.length; i++)
            if (emojis[i].indexOf(q) !== -1) out.push(emojis[i])
        filtered = out; currentIndex = 0
    }

    function toggle() { visible ? hide() : show() }

    function hide() {
        visible = false; searchField.text = ""; filtered = emojis; currentIndex = 0
    }

    function show() {
        visible = true; searchField.text = ""; filtered = emojis; currentIndex = 0
        Qt.callLater(() => searchField.forceActiveFocus())
    }

    function copyEmoji(emoji) {
        copyProc.command = ["wl-copy", emoji]
        copyProc.running = false; copyProc.running = true
        hide()
    }

    color: "transparent"

    MouseArea { anchors.fill: parent; onClicked: root.hide() }

    Rectangle {
        width: 400; height: 350
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 60
        color: Color.background; radius: Style.cornerRadius

        Column {
            anchors.fill: parent; anchors.margins: 16
            spacing: 8

            QQC.TextField {
                id: searchField
                width: parent.width; placeholderText: "Search emoji..."
                color: Color.foreground
                font.family: Style.font.family; font.pixelSize: Style.font.body

                onTextChanged: root.recomputeFiltered()

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Escape) { root.hide(); event.accepted = true }
                    else if (event.key === Qt.Key_Down && root.filtered.length > 0) {
                        root.currentIndex = 0; event.accepted = true
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Color.border }

            GridView {
                id: grid
                width: parent.width; height: parent.height - searchField.height - 40
                clip: true; cellWidth: width / root.cols; cellHeight: 32
                model: root.filtered; currentIndex: root.currentIndex

                delegate: Rectangle {
                    required property string modelData
                    required property int index
                    width: grid.cellWidth; height: grid.cellHeight
                    color: index === root.currentIndex ? Color.hover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: modelData; font.pixelSize: 20
                    }

                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onPositionChanged: root.currentIndex = index
                        onClicked: root.copyEmoji(modelData)
                    }
                }
            }
        }
    }

    Keys.priority: Keys.BeforeItem
    Keys.onPressed: function(event) {
        const k = event.key; const t = event.text
        if (k === Qt.Key_Escape) { root.hide(); event.accepted = true }
        else if (t === "j" || k === Qt.Key_Down) {
            root.currentIndex = Math.min(root.filtered.length - 1, root.currentIndex + 1)
            event.accepted = true
        } else if (t === "k" || k === Qt.Key_Up) {
            root.currentIndex = Math.max(0, root.currentIndex - 1)
            event.accepted = true
        } else if (t === "l" || k === Qt.Key_Right) {
            root.currentIndex = Math.min(root.filtered.length - 1, root.currentIndex + root.cols)
            event.accepted = true
        } else if (t === "h" || k === Qt.Key_Left) {
            root.currentIndex = Math.max(0, root.currentIndex - root.cols)
            event.accepted = true
        } else if (k === Qt.Key_Return && root.filtered.length > 0) {
            root.copyEmoji(root.filtered[root.currentIndex])
            event.accepted = true
        }
    }

    Process {
        id: copyProc
        running: false; command: []
    }
}
