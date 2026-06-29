// Audio indicator widget for the status bar.
// Shows a volume icon based on current level and mute state.
import QtQuick
import "../../Commons"
import "../../services"

Row {
    id: audio

    property real volume: Audio.volume
    property bool muted: Audio.muted

    spacing: 4

    // Volume icon using Nerd Font glyphs
    Text {
        property bool isMuted: audio.muted || audio.volume === 0
        property bool isLow: audio.volume > 0 && audio.volume < 0.33
        property bool isMedium: audio.volume >= 0.33 && audio.volume < 0.66

        text: isMuted ? "\uf00d" : isLow ? "\uf026" : isMedium ? "\uf027" : "\uf028"
        color: BarConfig.textColor
        font.family: BarConfig.fontFamily
        font.pixelSize: BarConfig.fontSize
        verticalAlignment: Text.AlignVCenter
    }
}