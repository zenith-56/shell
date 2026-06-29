pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    property bool available: UPower.displayDevice ? UPower.displayDevice.isPresent : false
    property real percentage: UPower.displayDevice ? UPower.displayDevice.percentage : 0
    property bool charging: UPower.displayDevice ? UPower.displayDevice.state === UPowerDeviceState.Charging : false
    property string status: UPower.displayDevice ? UPowerDeviceState.toString(UPower.displayDevice.state) : "unknown"
    property int timeToFull: UPower.displayDevice ? UPower.displayDevice.timeToFull : 0
    property int timeToEmpty: UPower.displayDevice ? UPower.displayDevice.timeToEmpty : 0

    function statusIcon(): string {
        if (!available)
            return "󱉝"; // nf-md-battery_outline
        if (charging)
            return "󰂅"; // nf-md-battery_charging
        if (percentage > 0.75)
            return "󰂀"; // nf-md-battery
        if (percentage > 0.50)
            return "󰁾"; // nf-md-battery_60
        if (percentage > 0.25)
            return "󰁻"; // nf-md-battery_30
        return "󰁺"; // nf-md-battery_10
    }
}
