// Audio OSD component.
// Shows icon, volume slider, and percentage in one row.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../services"
import "../../../utils"

PopupWindow {
    id: audioOsd

    property bool isOpen: false

    visible: isOpen
    grabFocus: true
    implicitWidth: 240
    implicitHeight: 40

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

    // Content container - single row
    RowLayout {
        anchors.fill: parent
        anchors.margins: Style.spacing.lg
        spacing: Style.spacing.lg

        Keys.onEscapePressed: {
            audioOsd.hide();
        }

        // Volume icon
        Text {
            text: Icons.volumeIcon(Audio.muted, Audio.volume)
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.title
            Layout.alignment: Qt.AlignVCenter
        }

        // Slider bar background
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            Layout.alignment: Qt.AlignVCenter
            color: Color.divider

            // Filled portion
            Rectangle {
                width: parent.width * Audio.volume
                height: parent.height
                color: Audio.muted ? Color.divider : Color.text
            }
        }

        // Volume percentage
        Text {
            text: Audio.muted ? "Mute" : Math.round(Audio.volume * 100) + "%"
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.bodySmall
            Layout.alignment: Qt.AlignVCenter
            Layout.minimumWidth: 36
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