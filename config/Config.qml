import Quickshell
import Quickshell.Io
import QtQuick

FileView {
    id: config

    readonly property string path: Qt.resolvedUrl("../../shell.json").toString().replace("file://", "")

    property var bar: ({})
    property var appearance: ({})

    watchChanges: true
    onLoaded: {
        const data = JSON.parse(text())
        config.bar = data.bar || {}
        config.appearance = data.appearance || {}
    }
    Component.onCompleted: reload()
}
