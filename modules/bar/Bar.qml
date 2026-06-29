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
    color: BarConfig.backgroundColor

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        spacing: 4

        Clock { }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 8

        spacing: 4

        BatteryIndicator { }
        NetworkIndicator { }
    }
}
