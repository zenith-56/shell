// Network indicator widget for the status bar.
// Shows a connection icon and opens popup on click.
import QtQuick
import "../../services"
import "../../Commons"
import "../../utils"

Item {
    id: network

    implicitWidth: Style.font.indicator + 2
    height: BarConfig.height

    Component.onCompleted: PopupControl.networkIndicator = network

    Text {
        anchors.centerIn: parent
        text: Network.connected ? Icons.signalIcon(Network.signalStrength) : Icons.ethernet
        color: BarConfig.textColor
        font.family: Style.font.family
        font.pixelSize: Style.font.indicator
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: PopupControl.toggle("network", network)
    }
}
