// Centralized icon mappings singleton.
// All Nerd Font glyphs in one place for easy reusability.
pragma Singleton
import QtQuick

QtObject {
    id: root

    // Audio icons
    readonly property string volumeOff: "\uf00d"     // nf-fa-volume_off
    readonly property string volumeDown: "\uf026"    // nf-fa-volume_down
    readonly property string volumeLow: "\uf027"     // nf-fa-volume_low
    readonly property string volumeHigh: "\uf028"    // nf-fa-volume_high
    readonly property string mute: "\uf04c"          // nf-fa-pause
    readonly property string unmute: "\uf04b"        // nf-fa-play
    readonly property string plus: "\uf067"          // nf-fa-plus
    readonly property string minus: "\uf068"         // nf-fa-minus

    // Battery icons
    readonly property string batteryOutline: "\uf590"   // nf-md-battery_outline
    readonly property string batteryCharging: "\uf0e7"  // nf-md-battery_charging
    readonly property string battery: "\uf578"          // nf-md-battery
    readonly property string battery60: "\uf577"        // nf-md-battery_60
    readonly property string battery40: "\uf576"        // nf-md-battery_40
    readonly property string battery20: "\uf575"        // nf-md-battery_20
    readonly property string heart: "\uf004"            // nf-fa-heart
    readonly property string laptop: "\uf109"           // nf-fa-laptop

    // Power profile icons
    readonly property string powerSaver: "\uf0e7"    // nf-fa-bolt
    readonly property string balanced: "\uf0e8"      // nf-fa-toggle-on
    readonly property string performance: "\uf135"   // nf-fa-rocket

    // Network icons
    readonly property string wifi: "\uf1eb"          // nf-fa-wifi
    readonly property string wifiWeak: "\uf131"      // nf-fa-signal
    readonly property string wifiMedium: "\uf132"    // nf-fa-signal-1
    readonly property string wifiStrong: "\uf133"    // nf-fa-signal-2
    readonly property string wifiNone: "\uf135"      // nf-fa-signal-3
    readonly property string ethernet: "\uf0ac"      // nf-fa-globe

    // Returns volume icon based on level
    function volumeIcon(muted: bool, volume: real): string {
        if (muted || volume === 0) return volumeOff;
        if (volume < 0.33) return volumeDown;
        if (volume < 0.66) return volumeLow;
        return volumeHigh;
    }

    // Returns battery icon based on level
    function batteryIcon(available: bool, charging: bool, percentage: real): string {
        if (!available) return batteryOutline;
        if (charging) return batteryCharging;
        if (percentage > 0.75) return battery;
        if (percentage > 0.50) return battery60;
        if (percentage > 0.25) return battery40;
        return battery20;
    }
}