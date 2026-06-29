// Audio OSD component.
// Shows a horizontal volume bar when volume changes.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../services"

PopupWindow {
    id: audioOsd

    property bool isOpen: false

    visible: isOpen
    grabFocus: true
    implicitWidth: 240
    implicitHeight: 60

    color: Color.background

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
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Keys.onEscapePressed: {
            audioOsd.hide();
        }

        // Volume icon and percentage
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Audio.muted || Audio.volume === 0 ? "\uf00d"
                    : Audio.volume < 0.33 ? "\uf026"
                    : Audio.volume < 0.66 ? "\uf027"
                    : "\uf028"
                color: Color.text
                font.family: BarConfig.fontFamily
                font.pixelSize: 14
            }

            Text {
                text: Audio.muted ? "Muted" : Math.round(Audio.volume * 100) + "%"
                color: Color.text
                font.family: BarConfig.fontFamily
                font.pixelSize: 12
                Layout.fillWidth: true
            }
        }

        // Volume bar background
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 3
            color: Color.divider

            // Filled portion
            Rectangle {
                width: parent.width * Audio.volume
                height: parent.height
                color: Audio.muted ? Color.divider : "#ffffff"
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