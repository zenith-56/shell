import QtQuick
import QtQuick.Controls
import "../../services"
import "../../config"

Text {
    id: clock

    property string time: Time.time
    property string date: Time.date

    text: time
    color: BarConfig.textColor
    font.family: BarConfig.fontFamily
    font.pixelSize: BarConfig.fontSize
    verticalAlignment: Text.AlignVCenter

    ToolTip.text: date
    ToolTip.visible: mouse.containsMouse

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
    }
}
