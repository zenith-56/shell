// PanelHero — hero section for popups.
// Large icon, title, and subtitle.
import QtQuick
import QtQuick.Layouts
import "../Commons" as Commons

ColumnLayout {
    id: root

    property string iconText: ""
    property string title: ""
    property string subtitle: ""

    spacing: Commons.Style.spacing.sm

    Text {
        text: root.iconText
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.iconLarge
        color: Commons.Color.text
        Layout.alignment: Qt.AlignHCenter
    }

    Text {
        visible: root.title !== ""
        text: root.title
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.heading
        color: Commons.Color.text
        Layout.alignment: Qt.AlignHCenter
    }

    Text {
        visible: root.subtitle !== ""
        text: root.subtitle
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.caption
        color: Commons.Color.textMuted
        Layout.alignment: Qt.AlignHCenter
    }
}
