// Shared structural style tokens for the shell.
// Spacing, typography, and bar dimensions from shell.json via ConfigLoader.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    // General
    readonly property int cornerRadius: 6

    // Spacing tokens
    readonly property QtObject spacing: QtObject {
        readonly property int xs: 3
        readonly property int sm: 4
        readonly property int md: 6
        readonly property int lg: 8
        readonly property int xl: 10
        readonly property int xxl: 12
    }

    // Animation tokens — durations and bezier curves from shell.json
    readonly property QtObject anim: QtObject {
        readonly property real scale: Util.get(ConfigLoader.raw, "anim.durations.scale", 1.0)

        readonly property int fastSpatial: Math.round(30 * scale)
        readonly property int defaultSpatial: Math.round(50 * scale)
        readonly property int slowSpatial: Math.round(65 * scale)
        readonly property int fastEffects: Math.round(15 * scale)
        readonly property int defaultEffects: Math.round(20 * scale)
        readonly property int slowEffects: Math.round(30 * scale)
        readonly property int small: Math.round(20 * scale)
        readonly property int normal: Math.round(40 * scale)
        readonly property int large: Math.round(60 * scale)
        readonly property int extraLarge: Math.round(100 * scale)

        readonly property var bezierSpatial: Util.get(ConfigLoader.raw, "anim.curves.spatial", [0.34, 1.56, 0.64, 1])
        readonly property var bezierEffects: Util.get(ConfigLoader.raw, "anim.curves.effects", [0.22, 1, 0.36, 1])
        readonly property var bezierEmphasized: Util.get(ConfigLoader.raw, "anim.curves.emphasized", [0.34, 1.56, 0.64, 1])
        readonly property var bezierStandard: Util.get(ConfigLoader.raw, "anim.curves.standard", [0.2, 0, 0, 1])
    }

    // Font tokens — read from ConfigLoader
    readonly property QtObject font: QtObject {
        readonly property string family: ConfigLoader.fontFamily
        readonly property int caption: ConfigLoader.fontCaption
        readonly property int bodySmall: 11
        readonly property int body: ConfigLoader.fontBody
        readonly property int subtitle: 13
        readonly property int title: ConfigLoader.fontTitle
        readonly property int indicator: ConfigLoader.fontIndicator
        readonly property int heading: ConfigLoader.fontHeading
        readonly property int large: ConfigLoader.fontLarge
        readonly property int icon: ConfigLoader.fontIcon
        readonly property int iconLarge: ConfigLoader.fontIconLarge
    }
}
