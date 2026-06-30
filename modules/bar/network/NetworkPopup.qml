// Network popup component.
// Shows WiFi, Ethernet, and hotspot controls.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../services"
import "../../../utils"

PopupWindow {
    id: networkPopup

    property bool isOpen: false

    visible: isOpen
    grabFocus: true
    implicitWidth: 360
    implicitHeight: 480

    color: Color.background

    onVisibleChanged: {
        if (!visible) {
            isOpen = false;
        }
    }

    // Signal to request password dialog
    signal requestPassword(string ssid)

    // Content container
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 24
        spacing: 12

        Keys.onEscapePressed: {
            networkPopup.hide();
        }

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Network.statusIcon()
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.iconLarge
            }

            Text {
                text: Network.connected ? (Network.wifi ? Network.ssid : "Ethernet") : "Disconnected"
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.heading
                font.bold: true
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Color.divider
        }

        // WiFi Section header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "WiFi"
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.title
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            // WiFi toggle
            Rectangle {
                width: 44
                height: 24
                radius: 12
                color: Network.wifiEnabled ? Color.success : Color.divider

                Rectangle {
                    x: Network.wifiEnabled ? 22 : 2
                    y: 2
                    width: 20
                    height: 20
                    radius: 10
                    color: Color.text

                    Behavior on x {
                        NumberAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Network.toggleWifi()
                }
            }
        }

        // WiFi networks list - scrollable
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 240
            color: Color.surface
            radius: 8
            clip: true

            Flickable {
                anchors.fill: parent
                anchors.margins: 8
                contentHeight: networkColumn.height
                clip: true
                flickableDirection: Flickable.VerticalFlick

                ColumnLayout {
                    id: networkColumn
                    width: parent.width
                    spacing: 4

                    // Scan button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        color: scanArea.containsMouse ? Color.divider : "transparent"
                        radius: 6

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: Icons.refresh
                                color: Color.text
                                font.family: Style.font.family
                                font.pixelSize: Style.font.body
                            }

                            Text {
                                text: "Scan"
                                color: Color.text
                                font.family: Style.font.family
                                font.pixelSize: Style.font.body
                            }
                        }

                        MouseArea {
                            id: scanArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Network.scanNetworks()
                        }
                    }

                    // Network list
                    Repeater {
                        model: Network.availableNetworks

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 44
                            color: netArea.containsMouse ? Color.divider : "transparent"
                            radius: 6

                            // Highlight if currently connected
                            property bool isConnected: Network.ssid === modelData.ssid

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                // Signal icon
                                Text {
                                    text: Icons.signalIcon(modelData.signal)
                                    color: Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.title
                                }

                                // SSID
                                Text {
                                    text: modelData.ssid
                                    color: isConnected ? Color.success : Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.body
                                    font.bold: isConnected
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                // Lock icon if secured
                                Text {
                                    text: modelData.security !== "None" ? Icons.lock : ""
                                    color: Color.textMuted
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.body
                                }
                            }

                            MouseArea {
                                id: netArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.security !== "None") {
                                        networkPopup.requestPassword(modelData.ssid);
                                    } else {
                                        Network.connect(modelData.ssid, "");
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Color.divider
        }

        // Hotspot Section
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Hotspot"
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.title
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            // Hotspot toggle
            Rectangle {
                width: 44
                height: 24
                radius: 12
                color: Network.hotspotActive ? Color.success : Color.divider

                Rectangle {
                    x: Network.hotspotActive ? 22 : 2
                    y: 2
                    width: 20
                    height: 20
                    radius: 10
                    color: Color.text

                    Behavior on x {
                        NumberAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Network.toggleHotspot()
                }
            }
        }
    }

    // Show popup below the bar
    function show(anchorWindow, anchorButtonItem) {
        var pos = anchorButtonItem.mapToItem(anchorWindow.contentItem, 0, 0);
        Network.scanNetworks();
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

    // Hide the popup
    function hide() {
        isOpen = false;
        visible = false
    }
}