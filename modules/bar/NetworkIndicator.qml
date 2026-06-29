import QtQuick
import "../../services"
import "../../config"

Row {
    id: network

    property bool connected: Network.connected
    property string ssid: Network.ssid
    property int signal: Network.signalStrength

    spacing: 4

    Text {
        text: Network.statusIcon()
        color: BarConfig.textColor
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        text: network.ssid || "Disconnected"
        color: BarConfig.textColor
        font.pixelSize: 12
        font.family: "monospace"
        verticalAlignment: Text.AlignVCenter
        visible: network.connected
    }
}
