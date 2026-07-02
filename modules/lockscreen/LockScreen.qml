// Lock screen plugin — custom Wayland session lock.
// Uses WlSessionLock for secure session locking and PamContext for authentication.
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import "../../Commons"
import "../../Ui"
import "../../utils"

Scope {
    id: root

    property bool isLocked: false
    property string errorMessage: ""

    // Initiate locking sequence and start PAM session
    function lock() {
        isLocked = true
        lockObject.locked = true
        errorMessage = ""
    }

    // Initiate unlocking sequence
    function unlock() {
        isLocked = false
        lockObject.locked = false
        errorMessage = ""
    }

    // Timer to clear the error message after 2 seconds
    Timer {
        id: errorMessageTimer
        interval: 2000
        onTriggered: root.errorMessage = ""
    }

    // Wayland session lock manager
    WlSessionLock {
        id: lockObject

        // Session lock surface covering the screen (opaque for security compatibility)
        surface: WlSessionLockSurface {
            id: lockSurface
            color: Color.background

            // FocusScope to capture all keyboard inputs securely
            FocusScope {
                anchors.fill: parent
                focus: true

                // PAM authentication context declared inside FocusScope for direct UI access
                PamContext {
                    id: pam
                    config: "vlock"
                    user: Quickshell.env("USER")

                    // Handle PAM authentication lifecycle results
                    onCompleted: function(result) {
                        if (result === PamResult.Success) {
                            root.unlock()
                        } else {
                            root.errorMessage = "INCORRECT PASSWORD"
                            pwInput.text = ""
                            errorMessageTimer.restart()
                            Qt.callLater(pam.start)
                        }
                    }
                }

                // Centered Lock screen UI content layout
                Column {
                    id: contentColumn
                    anchors.centerIn: parent
                    spacing: 16
                    opacity: 0

                    // Huge digital clock
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
                        height: 16
                    }

                    // Styled password input container
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 280
                        height: 40
                        radius: 6
                        color: Color.surface

                        // Custom placeholder text
                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            verticalAlignment: Text.AlignVCenter
                            text: "Enter Password..."
                            color: Color.textMuted
                            font.family: Style.font.family
                            font.pixelSize: 14
                            visible: pwInput.text === ""
                        }

                        // Native TextInput field
                        TextInput {
                            id: pwInput
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            verticalAlignment: Text.AlignVCenter
                            color: Color.text
                            font.family: Style.font.family
                            font.pixelSize: 14
                            echoMode: TextInput.Password
                            focus: true

                            // Submit response on Return key press
                            onAccepted: {
                                if (pam.responseRequired) {
                                    pam.respond(text)
                                }
                            }
                        }
                    }

                    // Dynamic error message label
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.errorMessage
                        color: Color.lowBattery
                        font.family: Style.font.family
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 1
                        visible: root.errorMessage !== ""
                    }

                    // Spacing divider
                    Item {
                        width: 1
                        height: 8
                    }

                    // Interactive instructions to unlock
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "PRESS ENTER TO UNLOCK"
                        color: Color.textMuted
                        font.family: Style.font.family
                        font.pixelSize: 11
                        font.letterSpacing: 2
                        font.bold: true
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
                    running: root.isLocked
                    interval: 1000
                    repeat: true
                    onTriggered: parent.updateTime()
                }

                Component.onCompleted: {
                    updateTime()
                    fadeInAnim.start()
                    pwInput.forceActiveFocus()
                    pam.start()
                }
            }

            // Smooth fade-in animation on lock screen creation
            NumberAnimation {
                id: fadeInAnim
                target: contentColumn
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }
    }
}
