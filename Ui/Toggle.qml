// Toggle switch component.
// Shows on/off state with label.
import QtQuick
import QtQuick.Layouts
import "../Commons" as Commons

RowLayout {
    id: root

    property string label: ""
    property bool checked: false

    signal toggled(bool checked)

    spacing: Commons.Style.spacing.md

    Text {
        text: root.label
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.body
        color: Commons.Color.text
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
    }

    Rectangle {
        width: 36
        height: 20
        radius: 10
        color: root.checked ? Commons.Color.accent : Commons.Color.divider
        Layout.alignment: Qt.AlignVCenter

        Behavior on color {
            CAnim { animType: Anim.FastEffects }
        }

        Rectangle {
            x: root.checked ? 16 : 2
            y: 2
            width: 16
            height: 16
            radius: 8
            color: Commons.Color.text

            Behavior on x {
                Anim { type: Anim.FastEffects }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.checked = !root.checked
                root.toggled(root.checked)
            }
        }
    }
}
