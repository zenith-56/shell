// Battery health display component.
// Shows battery health percentage, energy capacity, and device model.
import QtQuick
import QtQuick.Layouts
import "../../../Commons"
import "../../../services"
import "../../../utils"

ColumnLayout {
    id: batteryHealth

    property real healthPercentage: Battery.healthPercentage
    property real energy: Battery.energy
    property real energyCapacity: Battery.energyCapacity
    property string model: Battery.model

    spacing: 4

    // Health info row
    RowLayout {
        spacing: 8

        Text {
            text: Icons.heart
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.heading
        }

        Text {
            text: "Health: " + Math.round(batteryHealth.healthPercentage) + "%"
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.title
        }
    }

    // Energy capacity row
    RowLayout {
        spacing: 8

        Text {
            text: Icons.battery
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.heading
        }

        Text {
            text: "Capacity: " + batteryHealth.energy.toFixed(1) + " / " + batteryHealth.energyCapacity.toFixed(1) + " Wh"
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.title
        }
    }

    // Model row
    RowLayout {
        spacing: 8

        Text {
            text: Icons.laptop
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.heading
        }

        Text {
            text: "Model: " + batteryHealth.model
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.title
        }
    }
}