// Password input dialog for WiFi connection.
// Shows a text input field for entering WiFi password.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../utils"

PopupWindow {
    id: passwordDialog

    property bool isOpen: false
    property string networkSsid: ""
    property string password: ""
    property Item anchorItem: null

    visible: isOpen
    grabFocus: true
    implicitWidth: 340
    implicitHeight: 180

    color: Color.background

    onVisibleChanged: {
        if (!visible) {
            isOpen = false;
            passwordInput.text = "";
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Keys.onEscapePressed: {
            passwordDialog.hide();
        }

        // Title
        Text {
            text: "Connect to " + networkSsid
            color: Color.text
            font.family: Style.font.family
            font.pixelSize: Style.font.heading
            font.bold: true
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Color.divider
        }

        // Password label
        Text {
            text: "Password"
            color: Color.textMuted
            font.family: Style.font.family
            font.pixelSize: Style.font.body
        }

        // Password input
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            color: Color.surface
            radius: 6
            border.color: passwordInput.activeFocus ? Color.text : Color.divider
            border.width: 1

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 8
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                echoMode: TextInput.Password
                clip: true
                focus: true

                Keys.onReturnPressed: {
                    passwordDialog.connectToNetwork();
                }
                Keys.onEnterPressed: {
                    passwordDialog.connectToNetwork();
                }
            }
        }

        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Cancel button
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                color: cancelArea.containsMouse ? Color.divider : "transparent"
                border.color: Color.divider
                border.width: 1
                radius: 6

                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: Color.text
                    font.family: Style.font.family
                    font.pixelSize: Style.font.body
                }

                MouseArea {
                    id: cancelArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: passwordDialog.hide()
                }
            }

            // Connect button
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                color: connectArea.containsMouse ? Color.textMuted : Color.text
                radius: 6

                Text {
                    anchors.centerIn: parent
                    text: "Connect"
                    color: Color.background
                    font.family: Style.font.family
                    font.pixelSize: Style.font.body
                    font.bold: true
                }

                MouseArea {
                    id: connectArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: passwordDialog.connectToNetwork()
                }
            }
        }
    }

    function connectToNetwork() {
        Network.connect(networkSsid, passwordInput.text);
        hide();
    }

    function show(anchorWindow, anchorButtonItem, ssid: string) {
        networkSsid = ssid;
        var pos = anchorButtonItem.mapToItem(anchorWindow.contentItem, 0, 0);
        anchor.window = anchorWindow;
        anchor.rect = Qt.rect(
            pos.x + anchorButtonItem.width / 2 - implicitWidth / 2,
            anchorWindow.height,
            implicitWidth,
            implicitHeight
        );
        isOpen = true;
        visible = true;
    }

    function hide() {
        isOpen = false;
        visible = false;
    }
}