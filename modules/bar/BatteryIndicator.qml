import QtQuick
import "../../config"
import "../../services"

Row {
    id: battery

    property bool available: Battery.available
    property real percentage: Battery.percentage
    property bool charging: Battery.charging

    spacing: 4

    Text {
        text: Battery.statusIcon()
        color: BarConfig.textColor
        font.family: BarConfig.fontFamily
        font.pixelSize: BarConfig.fontSize
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        text: available ? Math.round(percentage * 100) + "%" : "N/A"
        color: BarConfig.textColor
        font.family: BarConfig.fontFamily
        font.pixelSize: BarConfig.fontSize
        verticalAlignment: Text.AlignVCenter
        visible: available
    }
}
