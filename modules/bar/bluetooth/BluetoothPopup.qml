// Bluetooth popup component.
// Shows Bluetooth toggle, paired devices, and available devices.
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../Commons"
import "../../../services"
import "../../../utils"

PopupWindow {
    id: bluetoothPopup

    property bool isOpen: false

    visible: isOpen
    grabFocus: true
    implicitWidth: 360
    implicitHeight: 480
    color: Color.background

    onVisibleChanged: if (!visible) isOpen = false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 24
        spacing: 12

        Keys.onEscapePressed: bluetoothPopup.hide()

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: Icons.bluetooth
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.iconLarge
            }
            Text {
                text: Bluetooth.connectedDevice ? Bluetooth.connectedDevice : "Bluetooth"
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.heading
                font.bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Color.divider
        }

        // Bluetooth toggle
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Text {
                text: "Bluetooth"
                color: Color.text
                font.family: Style.font.family
                font.pixelSize: Style.font.title
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 44
                height: 24
                radius: 12
                color: Bluetooth.enabled ? Color.success : Color.divider
                Rectangle {
                    x: Bluetooth.enabled ? 22 : 2
                    y: 2
                    width: 20
                    height: 20
                    radius: 10
                    color: Color.text
                    Behavior on x { NumberAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Bluetooth.toggle()
                }
            }
        }

        // Device list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 300
            color: Color.surface
            radius: 8
            clip: true

            Flickable {
                anchors.fill: parent
                anchors.margins: 8
                contentHeight: col.height
                clip: true
                flickableDirection: Flickable.VerticalFlick

                ColumnLayout {
                    id: col
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
                                text: Bluetooth.scanning ? Icons.refresh : Icons.bluetooth
                                color: Color.text
                                font.family: Style.font.family
                                font.pixelSize: Style.font.body
                            }
                            Text {
                                text: Bluetooth.scanning ? "Scanning..." : "Scan"
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
                            onClicked: Bluetooth.startScan()
                        }
                    }

                    Text {
                        text: "Paired Devices"
                        color: Color.textMuted
                        font.family: Style.font.family
                        font.pixelSize: Style.font.caption
                        Layout.topMargin: 8
                    }

                    Repeater {
                        model: Bluetooth.pairedDevices
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 52
                            color: pArea.containsMouse ? Color.divider : "transparent"
                            radius: 6
                            property bool isConnected: Bluetooth.connectedDevice === modelData.name

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8
                                Text {
                                    text: Icons.headphones
                                    color: Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.title
                                }
                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    Text {
                                        text: modelData.name
                                        color: isConnected ? Color.success : Color.text
                                        font.family: Style.font.family
                                        font.pixelSize: Style.font.body
                                        font.bold: isConnected
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: isConnected ? "Connected" : "Paired"
                                        color: Color.textMuted
                                        font.family: Style.font.family
                                        font.pixelSize: Style.font.caption
                                    }
                                }
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: cBtn.containsMouse ? Color.divider : "transparent"
                                    Text {
                                        anchors.centerIn: parent
                                        text: isConnected ? Icons.times : Icons.link
                                        color: Color.text
                                        font.family: Style.font.family
                                        font.pixelSize: Style.font.body
                                    }
                                    MouseArea {
                                        id: cBtn
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (isConnected) Bluetooth.disconnect(modelData.address);
                                            else Bluetooth.connect(modelData.address);
                                        }
                                    }
                                }
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: rBtn.containsMouse ? Color.divider : "transparent"
                                    Text {
                                        anchors.centerIn: parent
                                        text: Icons.trash
                                        color: Color.text
                                        font.family: Style.font.family
                                        font.pixelSize: Style.font.body
                                    }
                                    MouseArea {
                                        id: rBtn
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Bluetooth.remove(modelData.address)
                                    }
                                }
                            }
                            MouseArea {
                                id: pArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (isConnected) Bluetooth.disconnect(modelData.address);
                                    else Bluetooth.connect(modelData.address);
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.topMargin: 8
                        color: Color.divider
                        visible: Bluetooth.availableDevices.length > 0
                    }

                    Text {
                        text: "Available Devices"
                        color: Color.textMuted
                        font.family: Style.font.family
                        font.pixelSize: Style.font.caption
                        Layout.topMargin: 8
                        visible: Bluetooth.availableDevices.length > 0
                    }

                    Repeater {
                        model: Bluetooth.availableDevices
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 44
                            color: aArea.containsMouse ? Color.divider : "transparent"
                            radius: 6
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8
                                Text {
                                    text: Icons.bluetooth
                                    color: Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.title
                                }
                                Text {
                                    text: modelData.name
                                    color: Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.body
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: pairBtn.containsMouse ? Color.divider : "transparent"
                                    Text {
                                        anchors.centerIn: parent
                                        text: Icons.plus
                                        color: Color.text
                                        font.family: Style.font.family
                                        font.pixelSize: Style.font.body
                                    }
                                    MouseArea {
                                        id: pairBtn
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Bluetooth.pair(modelData.address)
                                    }
                                }
                            }
                            MouseArea {
                                id: aArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Bluetooth.connect(modelData.address)
                            }
                        }
                    }
                }
            }
        }
    }

    function show(anchorWindow, anchorButtonItem) {
        var pos = anchorButtonItem.mapToItem(anchorWindow.contentItem, 0, 0);
        Bluetooth.refreshAvailable();
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