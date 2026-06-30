// Launcher button widget for the status bar.
// Shows a launcher icon and opens popup on click.
import QtQuick
import "../../Commons"
import "../../utils"

Item {
    id: launcherButton

    property Item barWindow: null

    implicitWidth: Style.font.indicator + 2
    height: BarConfig.height

    Text {
        anchors.centerIn: parent
        text: Icons.launcher
        color: BarConfig.textColor
        font.family: Style.font.family
        font.pixelSize: Style.font.indicator
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (LauncherState.isOpen) {
                LauncherState.hide();
            } else {
                LauncherState.show(launcherButton, launcherButton.barWindow);
            }
        }
    }
}
