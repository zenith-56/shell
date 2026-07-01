// Bluetooth indicator widget for the status bar.
// Shows a Bluetooth icon and opens popup on click.
import QtQuick
import "../../services"
import "../../Commons"
import "../../utils"

Item {
    id: bluetooth

    implicitWidth: Style.font.indicator + 2
    height: BarConfig.height

    Component.onCompleted: PopupControl.bluetoothIndicator = bluetooth

    Text {
        anchors.centerIn: parent
        text: {
            if (!Bluetooth.enabled) return Icons.bluetoothOff;
            if (Bluetooth.connectedDevice) return Icons.headphones;
            return Icons.bluetooth;
        }
        color: Bluetooth.connectedDevice ? Color.success : BarConfig.textColor
        font.family: Style.font.family
        font.pixelSize: Bluetooth.connectedDevice ? Style.font.indicator + 8 : Style.font.indicator
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: PopupControl.toggle("bluetooth", bluetooth)
    }
}
