// Mutually-exclusive row of buttons — the form-style "pick one of N" pattern.
// Options: string[] (label == value) or [{ value, label }].
// Keyboard: h/l or Left/Right to navigate, Enter/Space to activate.
import QtQuick
import qs.Commons

Row {
    id: root

    property var options: []
    property string value: ""
    property int _focusedIndex: -1

    signal changed(string value)

    spacing: Style.spacing.md

    function optionValue(o) {
        return (o && typeof o === "object") ? String(o.value) : String(o)
    }
    function optionLabel(o) {
        return (o && typeof o === "object" && o.label !== undefined) ? String(o.label) : String(o)
    }
    function selectedIdx() {
        for (var i = 0; i < options.length; i++)
            if (optionValue(options[i]) === value) return i
        return -1
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            var idx = selectedIdx()
            _focusedIndex = idx < 0 ? 0 : idx
        } else {
            _focusedIndex = -1
        }
    }

    Keys.priority: Keys.BeforeItem
    Keys.onPressed: function(event) {
        const k = event.key; const t = event.text
        if (k === Qt.Key_Left || t === "h") {
            _focusedIndex = Math.max(0, (_focusedIndex < 0 ? 0 : _focusedIndex) - 1)
            event.accepted = true
        } else if (k === Qt.Key_Right || t === "l") {
            _focusedIndex = Math.min(options.length - 1, (_focusedIndex < 0 ? 0 : _focusedIndex) + 1)
            event.accepted = true
        } else if (k === Qt.Key_Return || k === Qt.Key_Enter || k === Qt.Key_Space) {
            if (_focusedIndex >= 0 && _focusedIndex < options.length)
                root.changed(optionValue(options[_focusedIndex]))
            event.accepted = true
        }
    }

    Repeater {
        model: root.options

        Rectangle {
            required property var modelData
            required property int index
            readonly property bool selected: root.optionValue(modelData) === root.value
            readonly property bool focused: root._focusedIndex === index

            width: 80; height: 32
            color: selected ? Color.accent : (focused ? Color.hover : "transparent")
            radius: Style.cornerRadius

            Text {
                anchors.centerIn: parent
                text: root.optionLabel(modelData)
                color: selected ? Color.background : Color.foreground
                font.family: Style.font.family; font.pixelSize: Style.font.body
            }

            MouseArea {
                anchors.fill: parent; hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: root._focusedIndex = index
                onClicked: root.changed(root.optionValue(modelData))
            }
        }
    }
}
