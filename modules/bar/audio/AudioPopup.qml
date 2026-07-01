// Volume OSD — compact bar anchored below the bar.
// Appears on volume change with animation, auto-hides after 2 seconds.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../../Commons"
import "../../../services"
import "../../../utils"
import "../../../Ui"

Item {
    id: osdRoot

    property bool showing: false

    onShowingChanged: {
        if (showing) {
            osdPopup.anchor.window = helper
            osdPopup.anchor.rect = Qt.rect(
                helper.width / 2 - osdPopup.implicitWidth / 2,
                helper.height,
                osdPopup.implicitWidth,
                osdPopup.implicitHeight
            )
            osdPopup.visible = true
            enterAnim.start()
            hideTimer.restart()
        } else {
            exitAnim.start()
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: osdRoot.showing = false
    }

    SequentialAnimation {
        id: enterAnim
        ParallelAnimation {
            Anim { target: card; property: "opacity"; from: 0; to: 1; type: Anim.DefaultEffects }
            Anim { target: card; property: "y"; from: -10; to: 0; type: Anim.DefaultSpatial }
        }
    }

    SequentialAnimation {
        id: exitAnim
        ParallelAnimation {
            Anim { target: card; property: "opacity"; from: 1; to: 0; type: Anim.FastEffects }
            Anim { target: card; property: "y"; from: 0; to: -10; type: Anim.FastEffects }
        }
        ScriptAction { script: osdPopup.visible = false }
    }

    PanelWindow {
        id: helper
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 0
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-osd-helper"
    }

    PopupWindow {
        id: osdPopup
        visible: false
        color: "transparent"
        implicitWidth: 350
        implicitHeight: 40
        grabFocus: false

        Item {
            anchors.fill: parent

            Rectangle {
                id: card
                anchors.fill: parent
                color: Color.background
                radius: 16
                opacity: 0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.spacing.lg
                    spacing: Style.spacing.lg

                    Text {
                        text: Icons.volumeIcon(Audio.muted, Audio.volume)
                        color: Color.text
                        font.family: Style.font.family
                        font.pixelSize: Style.font.title
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 3
                        Layout.alignment: Qt.AlignVCenter
                        color: Color.divider

                        Rectangle {
                            width: parent.width * Audio.volume
                            height: parent.height
                            color: Audio.muted ? Color.divider : Color.text

                            Behavior on width {
                                Anim { type: Anim.FastEffects }
                            }

                            Behavior on color {
                                CAnim { animType: Anim.FastEffects }
                            }
                        }
                    }

                    Text {
                        text: Audio.muted ? "Mute" : Math.round(Audio.volume * 100)
                        color: Color.text
                        font.family: Style.font.family
                        font.pixelSize: Style.font.bodySmall
                        Layout.alignment: Qt.AlignVCenter
                        Layout.minimumWidth: 15
                    }
                }
            }
        }
    }
}
