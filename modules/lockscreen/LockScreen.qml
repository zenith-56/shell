// Lock screen plugin — custom Wayland session lock.
// Uses WlSessionLock for secure session locking.
// Press Space to unlock.
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../Commons"
import "../../Ui"
import "../../utils"

WlSessionLock {
    id: lock

    property bool isLocked: false

    // Initiate locking sequence
    function lock() {
        isLocked = true
        locked = true
    }

    // Initiate unlocking sequence
    function unlock() {
        isLocked = false
        locked = false
    }

    // Session lock surface covering the screen (opaque for security compatibility)
    surface: WlSessionLockSurface {
        id: lockSurface
        color: Color.background

        // FocusScope to capture all keyboard inputs securely
        FocusScope {
            anchors.fill: parent
            focus: true

            // Lock on Space press
            Keys.onSpacePressed: lock.unlock()
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Space) {
                    lock.unlock()
                }
            }

            // Centered Lock screen UI content layout
            Column {
                id: contentColumn
                anchors.centerIn: parent
                spacing: 16
                opacity: 0

                // Huge premium digital clock
                Text {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Color.text
                    font.family: Style.font.family
                    font.pixelSize: 110
                    font.bold: true
                }

                // Elegant date representation
                Text {
                    id: dateText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Color.textMuted
                    font.family: Style.font.family
                    font.pixelSize: 20
                    font.letterSpacing: 1
                }

                // Spacing divider
                Item {
                    width: 1
                    height: 24
                }

                // Interactive instructions to unlock
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PRESS SPACE TO UNLOCK"
                    color: Color.textMuted
                    font.family: Style.font.family
                    font.pixelSize: 11
                    font.letterSpacing: 3
                    font.bold: true
                }

                // Smooth fade-in animation on lock screen creation
                NumberAnimation on opacity {
                    id: fadeInAnim
                    from: 0
                    to: 1
                    duration: 300
                    running: false
                }
            }

            // Helper to update clock texts
            function updateTime() {
                var now = new Date()
                var h = now.getHours().toString().padStart(2, "0")
                var m = now.getMinutes().toString().padStart(2, "0")
                timeText.text = h + ":" + m

                var days = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]
                var months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
                              "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
                dateText.text = days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate()
            }

            // Periodic timer to keep clock updated
            Timer {
                running: lock.isLocked
                interval: 1000
                repeat: true
                onTriggered: parent.updateTime()
            }

            Component.onCompleted: {
                updateTime()
                fadeInAnim.start()
                forceActiveFocus()
            }
        }
    }
}
