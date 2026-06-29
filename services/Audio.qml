// Audio service singleton.
// Manages volume level, mute state, and provides volume icons.
// Uses wpctl (WirePlumber) for volume control.
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real volume: 0.5        // Current volume level (0.0 - 1.0)
    property bool muted: false       // Whether audio is muted
    property string sinkName: ""     // Name of the active audio sink
    property real lastVolume: 0      // Previous volume for change detection

    // Emitted when volume changes
    signal volumeChangedSignal()

    // Poll volume status every 100ms for responsive OSD
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: root.updateVolume()
    }

    // Initialize on startup
    Component.onCompleted: updateVolume()

    // Get current volume from wpctl
    function updateVolume() {
        volumeProc.running = true;
    }

    // Process to get volume
    property Process volumeProc: Process {
        id: volumeProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                var output = text;
                var match = output.match(/Volume:\s+([\d.]+)/);
                if (match) {
                    var newVol = parseFloat(match[1]);
                    if (Math.abs(newVol - root.volume) > 0.001) {
                        root.lastVolume = root.volume;
                        root.volume = newVol;
                        root.volumeChangedSignal();
                    }
                }
                var newMuted = output.includes("[MUTED]");
                if (newMuted !== root.muted) {
                    root.muted = newMuted;
                    root.volumeChangedSignal();
                }
            }
        }
    }

    // Set volume using wpctl
    function setVolume(v: real): void {
        var clamped = Math.max(0, Math.min(1, v));
        root.volume = clamped;
        setVolumeProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", clamped.toString()];
        setVolumeProc.running = true;
    }

    // Process to set volume
    property Process setVolumeProc: Process {
        id: setVolumeProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0.5"]
    }

    // Toggle mute using wpctl
    function toggleMute(): void {
        root.muted = !root.muted;
        toggleMuteProc.running = true;
    }

    // Process to toggle mute
    property Process toggleMuteProc: Process {
        id: toggleMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
    }

    // Returns a Nerd Font glyph based on current volume level
    function volumeIcon(): string {
        if (muted || volume === 0) return "\uf00d";     // nf-fa-volume_off
        if (volume < 0.33) return "\uf026";              // nf-fa-volume_down
        if (volume < 0.66) return "\uf027";              // nf-fa-volume_low
        return "\uf028";                                 // nf-fa-volume_high
    }
}