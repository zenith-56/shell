import Quickshell
import Quickshell.Wayland
import QtQuick
import "../../config"
import "../../services"
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import "."

PanelWindow {
    id: bar

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: BarConfig.height
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    Rectangle {
        anchors.fill: parent
        color: BarConfig.backgroundColor
        opacity: 1.0
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        Clock {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            NetworkIndicator {}
            BatteryIndicator {}
        }
    }
}
