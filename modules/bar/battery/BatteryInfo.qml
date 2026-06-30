// Battery info display component.
// Shows large icon, percentage, and charging status.
import QtQuick
import QtQuick.Layouts
import "../../../Commons"
import "../../../services"
import "../../../utils"

RowLayout {
    id: batteryInfo

    property real percentage: Battery.percentage
    property bool charging: Battery.charging

    spacing: 12

    // Large battery icon
    Text {
        text: Icons.batteryIcon(Battery.available, Battery.charging, Battery.percentage)
        color: Battery.charging ? Color.success : (Battery.percentage <= 0.2 ? Color.lowBattery : Color.text)
        font.family: Style.font.family
        font.pixelSize: Style.font.iconLarge
        Layout.alignment: Qt.AlignVCenter
    }

    // Spacer to push text to the right
    Item {
        Layout.fillWidth: true
    }

    // Right side: percentage + status
    ColumnLayout {
        spacing: 2
        Layout.alignment: Qt.AlignVCenter

        // Percentage text
        Text {
            text: Math.round(percentage * 100) + "%"
            color: Battery.percentage <= 0.2 && !Battery.charging ? Color.lowBattery : Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.large
            font.bold: true
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignRight
        }

        // Charging status
        Text {
            text: "● " + (charging ? "Charging" : "Discharging")
            color: Battery.charging ? Color.success : (Battery.percentage <= 0.2 ? Color.lowBattery : Color.text)
            font.family: Style.font.family
            font.pixelSize: Style.font.body
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignRight
        }
    }
}