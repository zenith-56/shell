// Notification daemon plugin — displays and manages notifications.
// Uses Quickshell's NotificationServer for Wayland notifications.
// Shows a popup for new notifications and maintains a history list.
import QtQuick
import Quickshell
import "../../Commons"

Item {
    id: root

    property var notifications: []
    property int maxVisible: 5

    NotificationServer {
        id: notifServer
        keepOnReload: true

        onNotification: function(notif) {
            notif.expired.connect(() => removeNotif(notif))
            root.notifications.push(notif)
            root.notificationsChanged()
            hideTimer.restart()
        }
    }

    function removeNotif(notif) {
        var idx = root.notifications.indexOf(notif)
        if (idx !== -1) {
            root.notifications.splice(idx, 1)
            root.notificationsChanged()
        }
    }

    signal notificationsChanged()

    Timer {
        id: hideTimer
        interval: 5000; repeat: false
        onTriggered: {
            if (root.notifications.length > 0) {
                removeNotif(root.notifications[0])
                if (root.notifications.length > 0) hideTimer.restart()
            }
        }
    }

    Connections {
        target: root
        function onNotificationsChanged() {
            if (root.notifications.length > 0) {
                popup.visible = true
                showTimer.restart()
            } else {
                popup.visible = false
            }
        }
    }

    Timer {
        id: showTimer
        interval: 100; repeat: false
        onTriggered: popup.visible = true
    }

    // Notification popup
    Rectangle {
        id: popup
        visible: false
        width: 320
        height: Math.min(contentColumn.implicitHeight + 24, 200)
        anchors.right: parent ? parent.right : undefined
        anchors.top: parent ? parent.top : undefined
        anchors.margins: 8
        color: Color.background
        radius: Style.cornerRadius

        Column {
            id: contentColumn
            anchors.fill: parent; anchors.margins: 12
            spacing: 8

            Repeater {
                model: root.notifications

                Rectangle {
                    required property var modelData
                    width: contentColumn.width; height: 48
                    color: Color.hover; radius: Style.cornerRadius

                    Column {
                        anchors.fill: parent; anchors.margins: 8
                        spacing: 2

                        Text {
                            text: modelData.summary || "Notification"
                            color: Color.foreground
                            font.family: Style.font.family; font.pixelSize: Style.font.body
                            elide: Text.ElideRight; width: parent.width
                        }

                        Text {
                            text: modelData.body || ""
                            color: Color.muted
                            font.family: Style.font.family; font.pixelSize: Style.font.caption
                            elide: Text.ElideRight; width: parent.width
                            visible: text !== ""
                        }
                    }

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.removeNotif(modelData)
                    }
                }
            }

            Text {
                visible: root.notifications.length === 0
                text: "No notifications"
                color: Color.muted
                font.family: Style.font.family; font.pixelSize: Style.font.body
            }
        }

        MouseArea { anchors.fill: parent; onWheel: function(wheel) {
            if (wheel.angleDelta.y < 0 && root.notifications.length > 0) {
                root.removeNotif(root.notifications[0])
            }
        }}
    }
}
