// Numeric input field with +/- buttons.
// Wraps Qt's SpinBox with consistent styling.
import QtQuick
import QtQuick.Controls as QQC
import qs.Commons

Column {
    id: root

    property string label: ""
    property int value: 0
    property int from: 0
    property int to: 100
    property int stepSize: 1
    property alias field: spin

    signal modified(int value)

    spacing: Style.spacing.md

    Text {
        visible: root.label !== ""
        text: root.label
        color: Color.foreground
        font.family: Style.font.family
        font.pixelSize: Style.font.bodySmall
    }

    QQC.SpinBox {
        id: spin
        width: 120
        from: root.from; to: root.to
        stepSize: root.stepSize; value: root.value
        editable: true
        font.family: Style.font.family
        font.pixelSize: Style.font.body

        onValueModified: root.modified(value)

        contentItem: TextInput {
            text: spin.displayText
            font: spin.font
            color: Color.foreground
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            readOnly: !spin.editable
            validator: spin.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        background: Rectangle {
            color: Color.background
            radius: Style.cornerRadius
            border.color: Color.border; border.width: 1
        }
    }
}
