pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property int height: 32
    property string position: "top"
    property color backgroundColor: Colors.background
    property color textColor: Colors.text
    property color accentColor: Colors.accent
    property real radius: 0
    property string fontFamily: "FiraCode Nerd Font"
    property real fontSize: 14
    property var modules: ["clock", "workspaces", "battery", "network"]
}
