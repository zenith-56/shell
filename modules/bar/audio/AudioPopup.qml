// Audio OSD component.
// Shows a vertical volume bar when volume changes.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../services"

PopupWindow {
    id: audioOsd

    property bool isOpen: false
    property real lastVolume: 0

    visible: isOpen
    grabFocus: true
    implicitWidth: 40
    implicitHeight: 200

    color: "transparent"

    onVisibleChanged: {
        if (!visible) {
            isOpen = false;
        }
    }

    // Auto-hide timer
    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: audioOsd.hide()
    }

    // Content container
    Item {
        anchors.fill: parent
        anchors.margins: 8

        Keys.onEscapePressed: {
            audioOsd.hide();
        }

        // Volume icon at top
        Text {
            id: iconText
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: Audio.muted || Audio.volume === 0 ? "\uf00d"
                : Audio.volume < 0.33 ? "\uf026"
                : Audio.volume < 0.66 ? "\uf027"
                : "\uf028"
            color: Color.text
            font.family: BarConfig.fontFamily
            font.pixelSize: 16
        }

        // Vertical bar background
        Rectangle {
            id: barBg
            anchors.top: iconText.bottom
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 8
            radius: 4
            color: Color.divider

            // Filled portion
            Rectangle {
                width: parent.width
                height: parent.height * Audio.volume
                radius: parent.radius
                color: Audio.muted ? Color.divider : Color.accent
                anchors.bottom: parent.bottom
            }
        }
    }

    // Show OSD centered below the bar
    function show(anchorWindow) {
        hideTimer.restart();
        anchor.window = anchorWindow;
        anchor.rect = Qt.rect(
            anchorWindow.width / 2 - implicitWidth / 2,
            anchorWindow.height,
            implicitWidth,
            implicitHeight
        );
        isOpen = true;
        visible = true;
    }

    // Hide the OSD
    function hide() {
        isOpen = false;
        visible = false
    }
}