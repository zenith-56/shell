// Application launcher popup.
// Shows a searchable list of installed applications.
// Uses PanelWindow with WlrKeyboardFocus.Exclusive for native keyboard focus.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../../../Commons"
import "../../../services"
import "../../../utils"

PanelWindow {
    id: launcherPopup

    property int selectedIndex: 0
    property var filteredApps: []
    property int filteredCount: 0
    property Item focusTarget: searchInput

    implicitWidth: 400
    implicitHeight: 500
    color: "transparent"
    visible: LauncherState.isOpen
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "quickshell-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: LauncherState.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    onVisibleChanged: {
        if (!visible && LauncherState.isOpen) {
            LauncherState.isOpen = false;
        }
        if (visible) {
            filterApps("");
            searchInput.text = "";
            selectedIndex = 0;
            Qt.callLater(function() {
                if (visible && focusTarget)
                    focusTarget.forceActiveFocus();
            });
        }
    }

    Timer {
        id: initTimer
        interval: 200
        repeat: true
        running: true
        onTriggered: {
            var count = DesktopEntries.applications.values.length;
            if (count > 0) {
                filterApps("");
                initTimer.stop();
            }
        }
    }

    Component.onCompleted: {
        var count = DesktopEntries.applications.values.length;
        if (count > 0) filterApps("");
    }

    function filterApps(query: string): void {
        var all = DesktopEntries.applications.values;
        var count = all.length;
        var result = [];
        var q = query.toLowerCase();

        for (var i = 0; i < count; i++) {
            var app = all[i];
            if (!app || !app.name) continue;
            if (AppLauncherService.isExcluded(app)) continue;

            if (q !== "") {
                var nameMatch = app.name.toLowerCase().includes(q);
                var commentMatch = app.comment ? app.comment.toLowerCase().includes(q) : false;
                var genericMatch = app.genericName ? app.genericName.toLowerCase().includes(q) : false;
                if (!nameMatch && !commentMatch && !genericMatch) continue;
            }

            result.push(app);
        }

        result.sort(function(a, b) {
            return a.name.localeCompare(b.name);
        });

        filteredApps = result;
        filteredCount = result.length;
    }

    // Dismiss on click outside the card
    MouseArea {
        anchors.fill: parent
        onClicked: launcherPopup.close()
    }

    // Launcher card
    Rectangle {
        id: card
        property real cardWidth: 400
        property real cardHeight: 500

        // Position: below the launcher button, left-aligned
        x: {
            var btn = LauncherState.anchorButtonItem;
            var win = LauncherState.anchorWindow;
            if (!btn || !win) return 8;
            var pos = btn.mapToItem(win.contentItem, 0, 0);
            return Math.max(8, Math.min(pos.x, parent.width - cardWidth - 8));
        }
        y: {
            var win = LauncherState.anchorWindow;
            if (!win) return 40;
            return win.height + 4;
        }
        width: cardWidth
        height: cardHeight
        color: Color.background
        radius: 8

        // Swallow clicks on the card
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Search bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: searchInput.activeFocus ? Color.divider : Color.surface
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: Icons.search
                        color: Color.textMuted
                        font.family: Style.font.family
                        font.pixelSize: Style.font.body
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        color: Color.text
                        font.family: Style.font.family
                        font.pixelSize: Style.font.body
                        clip: true
                        focus: true
                        activeFocusOnPress: true

                        onTextChanged: {
                            filterApps(text);
                            selectedIndex = 0;
                        }

                        Keys.onUpPressed: moveSelection(-1)
                        Keys.onDownPressed: moveSelection(1)
                        Keys.onReturnPressed: launchSelected()
                        Keys.onEnterPressed: launchSelected()
                        Keys.onEscapePressed: launcherPopup.close()
                    }
                }
            }

            // Applications list
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Color.surface
                radius: 8
                clip: true

                ListView {
                    id: appList
                    anchors.fill: parent
                    anchors.margins: 8
                    model: filteredApps
                    currentIndex: selectedIndex
                    highlight: Rectangle {
                        color: Color.divider
                        radius: 6
                    }
                    highlightFollowsCurrentItem: false

                    delegate: Rectangle {
                        width: appList.width
                        height: 40
                        color: "transparent"
                        radius: 6

                        property bool isSelected: index === selectedIndex

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 12

                            IconImage {
                                implicitWidth: 24
                                implicitHeight: 24
                                source: modelData.icon ? "image://icon/" + modelData.icon : ""
                                visible: modelData.icon !== ""
                            }

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 4
                                color: Color.divider
                                visible: !modelData.icon

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.name.charAt(0).toUpperCase()
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
                                    text: modelData.name
                                    color: Color.text
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.body
                                    font.bold: isSelected
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.comment || modelData.execString
                                    color: Color.textMuted
                                    font.family: Style.font.family
                                    font.pixelSize: Style.font.caption
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                    visible: modelData.comment || modelData.execString
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                selectedIndex = index;
                                launchSelected();
                            }
                            onEntered: {
                                selectedIndex = index;
                                appList.currentIndex = index;
                            }
                        }
                    }
                }
            }

            // Status bar
            Text {
                text: filteredCount + " applications"
                color: Color.textMuted
                font.family: Style.font.family
                font.pixelSize: Style.font.caption
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    function moveSelection(delta: int): void {
        var newIndex = selectedIndex + delta;
        if (newIndex >= 0 && newIndex < filteredCount) {
            selectedIndex = newIndex;
            appList.currentIndex = newIndex;
            appList.positionViewAtIndex(newIndex, ListView.Contain);
        }
    }

    function launchSelected(): void {
        if (selectedIndex >= 0 && selectedIndex < filteredCount) {
            var app = filteredApps[selectedIndex];
            app.execute();
            close();
        }
    }

    function close(): void {
        LauncherState.isOpen = false;
    }
}
