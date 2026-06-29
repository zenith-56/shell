// Audio indicator widget for the status bar.
// Shows a volume icon based on current level and mute state.
// Click to toggle mute.
import QtQuick
import "../../Commons"
import "../../services"

Item {
    id: audio

    property real volume: Audio.volume
    property bool muted: Audio.muted

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    // Volume icon using Nerd Font glyphs
    Text {
        id: iconText
        text: audio.muted || audio.volume === 0 ? "\uf00d"     // nf-fa-volume_off
            : audio.volume < 0.33 ? "\uf026"                    // nf-fa-volume_down
            : audio.volume < 0.66 ? "\uf027"                    // nf-fa-volume_low
            : "\uf028"                                          // nf-fa-volume_high
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