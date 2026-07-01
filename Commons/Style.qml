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
