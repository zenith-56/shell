// Searchable multi-select dropdown with checkbox list.
// Options: string[] or [{ value, label }].
// Values: array of selected strings.
// Keyboard: Down to open, j/k to navigate, Space to toggle, Escape to close.
import QtQuick
import QtQuick.Controls as QQC
import qs.Commons

Item {
    id: root

    property string label: ""
    property var values: []
    property var options: []
    property string placeholderText: "Search..."
    property string noSelectionText: "None selected"
    property int rowHeight: 32
    property int popupMaxHeight: 200

    readonly property bool popupOpen: popup.opened
    function open() { popup.open() }
    function close() { popup.close() }
    function toggle() { popup.opened ? popup.close() : popup.open() }

    signal changed(var values)

    property var filtered: []
    property var _normalized: []

    function normalize() {
        var out = []
        for (var i = 0; i < options.length; i++) {
            var o = options[i]
            if (o && typeof o === "object")
                out.push({ value: String(o.value), label: String(o.label || o.value) })
            else
                out.push({ value: String(o), label: String(o) })
        }
        _normalized = out
    }

    function recomputeFiltered() {
        var q = searchField.text.toLowerCase()
        if (!q) { filtered = _normalized; return }
        var out = []
        for (var i = 0; i < _normalized.length; i++) {
            if (_normalized[i].label.toLowerCase().indexOf(q) !== -1)
                out.push(_normalized[i])
        }
        filtered = out
    }

    function isSelected(v) {
        if (!values || typeof values.length !== "number") return false
        for (var i = 0; i < values.length; i++)
            if (String(values[i]) === String(v)) return true
        return false
    }

    function toggleValue(v) {
        var arr = []
        if (values && typeof values.length === "number")
            for (var i = 0; i < values.length; i++) arr.push(values[i])
        var idx = arr.indexOf(v)
        if (idx === -1) arr.push(v); else arr.splice(idx, 1)
        values = arr; changed(arr)
    }

    function selectionLabel() {
        if (!values || values.length === 0) return ""
        if (values.length <= 3) {
            var labels = []
            for (var i = 0; i < values.length; i++) {
                for (var j = 0; j < _normalized.length; j++)
                    if (_normalized[j].value === values[i]) { labels.push(_normalized[j].label); break }
            }
            return labels.join(", ")
        }
        return values.length + " selected"
    }

    onOptionsChanged: normalize()
    Component.onCompleted: normalize()

    implicitWidth: parent ? parent.width : 150
    implicitHeight: rowHeight

    Rectangle {
        anchors.fill: parent
        color: Color.background; radius: Style.cornerRadius

        Text {
            anchors.left: parent.left; anchors.right: chevron.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 8; anchors.rightMargin: 4
            text: selectionLabel() || root.noSelectionText
            color: selectionLabel() ? Color.foreground : Color.muted
            font.family: Style.font.family; font.pixelSize: Style.font.body
            elide: Text.ElideRight
        }

        Text {
            id: chevron
            anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            text: "\uf078"; color: Color.muted
            font.family: "FiraCode Nerd Font"; font.pixelSize: Style.font.body
        }

        MouseArea {
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
            onClicked: { root.normalize(); root.recomputeFiltered(); popup.opened ? popup.close() : popup.open() }
        }
    }

    QQC.Popup {
        id: popup
        parent: Overlay.overlay
        x: root.mapToItem(Overlay.overlay, 0, 0).x
        y: root.mapToItem(Overlay.overlay, 0, 0).y + root.height + 2
        width: root.width
        implicitHeight: Math.min(contentColumn.implicitHeight + 16, root.popupMaxHeight)
        padding: 8; focus: true

        background: Rectangle { color: Color.background; radius: Style.cornerRadius }

        onOpened: { root.recomputeFiltered(); Qt.callLater(() => searchField.forceActiveFocus()) }
        onClosed: searchField.text = ""

        contentItem: Column {
            id: contentColumn; spacing: 4

            QQC.TextField {
                id: searchField
                width: parent.width; placeholderText: root.placeholderText
                color: Color.foreground; font.family: Style.font.family; font.pixelSize: Style.font.body

                onTextChanged: { root.recomputeFiltered(); if (listView.count > 0) listView.currentIndex = 0 }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Escape) { popup.close(); event.accepted = true }
                    else if (event.key === Qt.Key_Down && listView.count > 0) {
                        listView.currentIndex = 0; listView.forceActiveFocus(); event.accepted = true
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Color.border }

            ListView {
                id: listView
                width: parent.width; height: Math.min(contentHeight, root.popupMaxHeight - 50)
                clip: true; model: root.filtered; currentIndex: -1
                keyNavigationEnabled: false

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: function(event) {
                    const k = event.key; const t = event.text
                    if (k === Qt.Key_Escape) { popup.close(); event.accepted = true }
                    else if ((k === Qt.Key_Down || t === "j") && currentIndex < count - 1) {
                        currentIndex++; event.accepted = true
                    } else if ((k === Qt.Key_Up || t === "k") && currentIndex > 0) {
                        currentIndex--; event.accepted = true
                    } else if (k === Qt.Key_Up && currentIndex === 0) {
                        searchField.forceActiveFocus(); event.accepted = true
                    } else if (k === Qt.Key_Space || k === Qt.Key_Return) {
                        if (currentIndex >= 0) root.toggleValue(root.filtered[currentIndex].value)
                        event.accepted = true
                    }
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    readonly property bool selected: root.isSelected(modelData.value)
                    width: listView.width; height: 28
                    color: index === listView.currentIndex ? Color.hover : "transparent"
                    radius: 4

                    Row {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8; spacing: 8

                        Rectangle {
                            width: 14; height: 14; radius: 3
                            anchors.verticalCenter: parent.verticalCenter
                            color: selected ? Color.accent : "transparent"
                            border.color: selected ? Color.accent : Color.border; border.width: 1

                            Text {
                                anchors.centerIn: parent; visible: selected
                                text: "\uf00c"; color: Color.background
                                font.family: "FiraCode Nerd Font"; font.pixelSize: 9
                            }
                        }

                        Text {
                            text: modelData.label; color: Color.foreground
                            font.family: Style.font.family; font.pixelSize: Style.font.body
                            elide: Text.ElideRight; anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onPositionChanged: listView.currentIndex = index
                        onClicked: root.toggleValue(modelData.value)
                    }
                }
            }
        }
    }
}
