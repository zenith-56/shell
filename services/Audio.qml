// Audio service singleton.
// Manages volume level, mute state, and provides volume icons.
// Integrates with PipeWire for real volume control.
pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    property real volume: 0.5        // Current volume level (0.0 - 1.0)
    property bool muted: false       // Whether audio is muted
    property string sinkName: ""     // Name of the active audio sink

    // Get the default audio sink from PipeWire
    property var defaultSink: Pipewire.defaultAudioSink

    // Update volume from PipeWire sink
    Connections {
        target: root.defaultSink
        function onVolumeChanged() {
            if (root.defaultSink) {
                root.volume = root.defaultSink.volume;
                root.muted = root.defaultSink.muted;
                root.sinkName = root.defaultSink.description || root.defaultSink.name || "";
            }
        }
        function onMutedChanged() {
            if (root.defaultSink) {
                root.muted = root.defaultSink.muted;
            }
        }
    }

    // Initialize from current sink state
    Component.onCompleted: {
        if (defaultSink) {
            root.volume = defaultSink.volume;
            root.muted = defaultSink.muted;
            root.sinkName = defaultSink.description || defaultSink.name || "";
        }
    }

    // Clamp volume to valid range [0, 1]
    function setVolume(v: real): void {
        var clamped = Math.max(0, Math.min(1, v));
        root.volume = clamped;
        if (defaultSink) {
            defaultSink.volume = clamped;
        }
    }

    // Toggle mute state on/off
    function toggleMute(): void {
        root.muted = !root.muted;
        if (defaultSink) {
            defaultSink.muted = root.muted;
        }
    }

    // Returns a Nerd Font glyph based on current volume level
    function volumeIcon(): string {
        if (muted || volume === 0) return "\uf00d";     // nf-fa-volume_off
        if (volume < 0.33) return "\uf026";              // nf-fa-volume_down
        if (volume < 0.66) return "\uf027";              // nf-fa-volume_low
        return "\uf028";                                 // nf-fa-volume_high
    }
}