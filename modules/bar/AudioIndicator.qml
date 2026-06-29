// Audio indicator widget for the status bar.
// Shows a volume icon based on current level and mute state.
// Click to toggle mute.
import QtQuick
import "../../Commons"
import "../../services"

Item {
    id: audio

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    // Volume icon using Nerd Font glyphs
    Text {
        id: iconText
        text: Audio.muted || Audio.volume === 0 ? ""     // nf-fa-volume_off
            : Audio.volume < 0.33 ? ""                    // nf-fa-volume_down
            : Audio.volume < 0.66 ? ""                    // nf-fa-volume_low
            : ""                                          // nf-fa-volume_high
        color: BarConfig.textColor
        font.family: BarConfig.fontFamily
        font.pixelSize: BarConfig.fontSize
        verticalAlignment: Text.AlignVCenter
    }

    // Click to toggle mute
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.toggleMute()
    }
}