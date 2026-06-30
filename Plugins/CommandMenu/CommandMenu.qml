// Command menu plugin — quick command launcher.
// Opens a searchable overlay to run shell commands or launch apps.
// Keyboard: Ctrl+Space to toggle, j/k to navigate, Enter to execute, Escape to close.
import QtQuick
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Io
import "../../Commons"

PanelWindow {
    id: root

    visible: false
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.namespace: "command-menu"
    screen: BarConfig.screen
    anchors.top: true; anchors.left: true; anchors.right: true

    readonly property var commands: [
        { name: "Terminal", cmd: "kitty" },
        { name: "Browser", cmd: "firefox" },
        { name: "Files", cmd: "dolphin" },
        { name: "Settings", cmd: "systemsettings" },
        { name: "Screenshot", cmd: "grimblast copy area" },
        { name: "Color Picker", cmd: "hyprpicker -a" },
        { name: "Lock Screen", cmd: "loginctl lock-session" },
        { name: "Logout", cmd: "hyprctl dispatch exit" },
        { name: "Reboot", cmd: "systemctl reboot" },
        { name: "Shutdown", cmd: "systemctl poweroff" }
    ]

    property var filtered: commands
    property int currentIndex: 0

    function recomputeFiltered() {
        var q = searchField.text.toLowerCase()
        if (!q) { filtered = commands; return }
        var out = []
        for (var i = 0; i < commands.length; i++) {
            if (commands[i].name.toLowerCase().indexOf(q) !== -1)
                out.push(commands[i])
        }
        filtered = out; currentIndex = 0
    }

    function toggle() {
        if (visible) { hide() } else { show() }
    }

    function hide() {
        visible = false
        searchField.text = ""
        filtered = commands
        currentIndex = 0
    }

    function show() {
        visible = true
        searchField.text = ""
        filtered = commands
        currentIndex = 0
        Qt.callLater(() => searchField.forceActiveFocus())
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

            QQC.TextField {
                id: searchField
                width: parent.width; placeholderText: "Type a command..."
                color: Color.foreground
                font.family: Style.font.family; font.pixelSize: Style.font.body

                onTextChanged: root.recomputeFiltered()

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Escape) { root.hide(); event.accepted = true }
                    else if (event.key === Qt.Key_Down) {
                        root.currentIndex = Math.min(root.filtered.length - 1, root.currentIndex + 1)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        root.currentIndex = Math.max(0, root.currentIndex - 1)
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return && root.filtered.length > 0) {
                        var cmd = root.filtered[root.currentIndex].cmd
                        root.hide()
                        cmdProc.command = ["sh", "-c", cmd]
                        cmdProc.running = false
                        cmdProc.running = true
                        event.accepted = true
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Color.border }

            Repeater {
                model: root.filtered

                Rectangle {
                    required property var modelData
                    required property int index
                    width: contentColumn.width; height: 32
                    color: index === root.currentIndex ? Color.hover : "transparent"
                    radius: Style.cornerRadius

                    Text {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        text: modelData.name; color: Color.foreground
                        font.family: Style.font.family; font.pixelSize: Style.font.body
                    }

                    MouseArea {
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onPositionChanged: root.currentIndex = index
                        onClicked: {
                            root.hide()
                            cmdProc.command = ["sh", "-c", modelData.cmd]
                            cmdProc.running = false; cmdProc.running = true
                        }
                    }
                }
            }

            Text {
                visible: root.filtered.length === 0
                text: "No matching commands"
                color: Color.muted
                font.family: Style.font.family; font.pixelSize: Style.font.body
            }
        }
    }

    Process {
        id: cmdProc
        running: false
        command: []
    }
}
