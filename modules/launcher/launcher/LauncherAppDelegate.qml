// App list delegate component for the launcher.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../../../Commons"
import "../../../utils"
import "../../../Ui"

Rectangle {
    id: root

    property bool isSelected: false
    property var appData: null
    readonly property string iconSource: appData && appData.icon ? Quickshell.iconPath(appData.icon, true) : ""

    width: ListView.view.width
    height: 40
    color: root.isSelected ? Color.divider : "transparent"
    radius: 6

    Behavior on color {
        CAnim { animType: Anim.FastEffects }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        IconImage {
            implicitWidth: 24
            implicitHeight: 24
            source: root.iconSource
            visible: source !== ""
        }

        Rectangle {
            width: 24
            height: 24
            radius: 4
            color: Color.divider
            visible: root.iconSource === ""

            Text {
                anchors.centerIn: parent
                text: appData ? appData.name.charAt(0).toUpperCase() : ""
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                font.bold: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: appData ? appData.name : ""
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                font.bold: root.isSelected
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: appData ? (appData.comment || appData.execString || "") : ""
                color: Color.textMuted
                font.family: Style.font.family
                font.pixelSize: Style.font.caption
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: text !== ""
            }
        }
    }
}
