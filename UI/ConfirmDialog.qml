// Confirmation dialog with cancel/confirm buttons.
// Shows a modal overlay with a message and two buttons.
// Keyboard: Escape cancels, Tab cycles, Enter activates.
import QtQuick
import qs.Commons

Rectangle {
    id: root

    property bool opened: false
    property string message: ""
    property string cancelText: "Cancel"
    property string confirmText: "Confirm"
    property int selectedIndex: 1

    color: Color.overlay
    visible: opened

    signal canceled()
    signal confirmed()

    function handleKey(event) {
        if (!opened) return false
        const k = event.key
        if (k === Qt.Key_Escape) { canceled(); return true }
        if (k === Qt.Key_Left || k === Qt.Key_Right || k === Qt.Key_Tab || k === Qt.Key_Backtab) {
            selectedIndex = selectedIndex === 0 ? 1 : 0; return true
        }
        if (k === Qt.Key_Return || k === Qt.Key_Enter) {
            selectedIndex === 0 ? canceled() : confirmed(); return true
        }
        return false
    }

    MouseArea { anchors.fill: parent; onClicked: root.canceled() }

    Rectangle {
        width: Math.min(parent.width - 96, 370)
        height: 132
        anchors.centerIn: parent
        color: Color.background
        radius: Style.cornerRadius

        MouseArea { anchors.fill: parent }

        Text {
            anchors.left: parent.left; anchors.right: parent.right
            anchors.top: parent.top; anchors.margins: 18
            text: root.message; color: Color.foreground
            font.family: Style.font.family; font.pixelSize: Style.font.title
            wrapMode: Text.WordWrap
        }

        Row {
            anchors.right: parent.right; anchors.bottom: parent.bottom
            anchors.margins: 18; spacing: 10

            Repeater {
                model: [root.cancelText, root.confirmText]

                Rectangle {
                    required property int index
                    required property string modelData
                    readonly property bool selected: root.selectedIndex === index

                    width: 88; height: 34
                    color: selected ? Color.accent : "transparent"
                    radius: Style.cornerRadius

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: selected ? Color.background : Color.foreground
                        font.family: Style.font.family; font.pixelSize: Style.font.caption
                    }

                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selectedIndex = index
                        onClicked: index === 0 ? root.canceled() : root.confirmed()
                    }
                }
            }
        }
    }
}
