// Audio indicator widget for the status bar.
// Shows a volume icon and OSD popup on volume change.
import QtQuick
import "../../Commons"
import "../../services"
import "audio"

Item {
    id: audio

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    // Volume icon using Nerd Font glyphs
    Text {
        id: iconText
        text: Audio.muted || Audio.volume === 0 ? "\uf00d"     // nf-fa-volume_off
            : Audio.volume < 0.33 ? "\uf026"                    // nf-fa-volume_down
            : Audio.volume < 0.66 ? "\uf027"                    // nf-fa-volume_low
            : "\uf028"                                          // nf-fa-volume_high
        color: BarConfig.textColor
        font.family: BarConfig.fontFamily
        font.pixelSize: BarConfig.fontSize
        verticalAlignment: Text.AlignVCenter
    }

    // Show OSD when volume changes
    Connections {
        target: Audio
        function onVolumeChangedSignal() {
            audioOsd.show(bar);
        }
    }

    // Audio OSD instance
    AudioPopup {
        id: audioOsd
    }
}