// Lock screen plugin — custom Wayland session lock.
// Uses WlSessionLock for secure session locking.
// Press Escape to unlock.
import QtQuick
import Quickshell
import Quickshell.Wayland

WlSessionLock {
    id: lock

    property bool isLocked: false

    function lock() {
        isLocked = true
        locked = true
    }

    function unlock() {
        isLocked = false
        locked = false
    }

    surface: WlSessionLockSurface {
        color: "#000000"

        // FocusScope captures all keyboard input
        FocusScope {
            anchors.fill: parent
            focus: true

            Keys.onEscapePressed: lock.unlock()
            Keys.onReturnPressed: lock.unlock()
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape || event.key === Qt.Key_Return) {
                    lock.unlock()
                }
            }

            // Center content
            Column {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#ffffff"
                    font.family: Style.font.family
                    font.pixelSize: 96
                    font.bold: true
                }

                Text {
                    id: dateText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#999999"
                    font.family: Style.font.family
                    font.pixelSize: 24
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Press Escape to unlock"
                    color: "#666666"
                    font.family: Style.font.family
                    font.pixelSize: 16
                    anchors.topMargin: 40
                }
            }

            function updateTime() {
                var now = new Date()
                var h = now.getHours().toString().padStart(2, "0")
                var m = now.getMinutes().toString().padStart(2, "0")
                timeText.text = h + ":" + m

                var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                var months = ["January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December"]
                dateText.text = days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate()
            }

            Timer {
                running: lock.isLocked
                interval: 1000
                repeat: true
                onTriggered: parent.updateTime()
            }

            Component.onCompleted: {
                updateTime()
                forceActiveFocus()
            }
        }

        Component.onCompleted: forceActiveFocus()
    }
}
