// Network indicator widget for the status bar.
// Shows a connection icon and opens popup on click.
import QtQuick
import "../../services"
import "../../Commons"
import "../../utils"
import "network"

Item {
    id: network

    property bool connected: Network.connected
    property string ssid: Network.ssid
    property int signal: Network.signalStrength

    width: iconText.implicitWidth
    height: iconText.implicitHeight

    Text {
        id: iconText
        text: Network.statusIcon()
        color: BarConfig.textColor
        font.family: Style.font.family
        font.pixelSize: Style.font.title + 2
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (networkPopup.isOpen) {
                networkPopup.hide();
            } else {
                networkPopup.show(bar, iconText);
            }
        }
    }

    NetworkPopup {
        id: networkPopup
        onRequestPassword: function(ssid) {
            passwordDialog.show(bar, iconText, ssid);
        }
    }

    PasswordDialog {
        id: passwordDialog
    }
}