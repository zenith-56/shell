import QtQuick
import "../../config"

Text {
    id: workspaces

    property int current: 1
    property int total: 5

    text: {
        var result = ""
        for (var i = 1; i <= total; i++) {
            if (i === current) result += "● "
            else result += "○ "
        }
        return result
    }
    color: BarConfig.textColor
    font.family: BarConfig.fontFamily
    font.pixelSize: BarConfig.fontSize
    verticalAlignment: Text.AlignVCenter
}
