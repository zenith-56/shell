import QtQuick
import "../../config"
import Quickshell.Services.UPower

Row {
    id: battery

    property bool available: UPower.displayDevice.isPresent
    property real percentage: UPower.displayDevice.percentage
    property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging

    spacing: 4

    Text {
        text: {
            if (!battery.available) return "battery-missing"
            if (battery.charging) return "battery-charging"
            if (battery.percentage > 75) return "battery-full"
            if (battery.percentage > 50) return "battery-good"
            if (battery.percentage > 25) return "battery-low"
            return "battery-empty"
        }
        color: BarConfig.textColor
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        text: available ? Math.round(percentage) + "%" : "N/A"
        color: BarConfig.textColor
        font.pixelSize: 12
        font.family: "monospace"
        verticalAlignment: Text.AlignVCenter
        visible: available
    }
}
