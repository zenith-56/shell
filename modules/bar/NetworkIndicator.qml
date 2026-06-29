// Network indicator widget for the status bar.
// Shows a connection icon when connected.
import QtQuick
import "../../services"
import "../../Commons"
import "../../utils"

Row {
    id: network

    property bool connected: Network.connected
    property string ssid: Network.ssid
    property int signal: Network.signalStrength

    spacing: 4

    Text {
        text: Network.statusIcon()
        color: BarConfig.textColor
        font.family: Style.font.family
        font.pixelSize: Style.font.title + 2
        verticalAlignment: Text.AlignVCenter
    }
}