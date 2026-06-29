// Workspaces service singleton.
// Polls niri via IPC to expose workspace state.
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int current: 1           // Active workspace index
    property int total: 1             // Total workspace count
    property var workspaces: []       // Raw workspace list from niri

    // Polls niri for workspace changes
    Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: queryProc.exec(["niri", "msg", "-j", "workspaces"])
    }

    // Reads workspace list from niri IPC
    Process {
        id: queryProc
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                try {
                    var data = JSON.parse(this.text);
                    root.workspaces = data;
                    root.total = data.length;

                    for (var i = 0; i < data.length; i++) {
                        if (data[i].is_active) {
                            root.current = data[i].idx;
                            break;
                        }
                    }
                } catch (e) {
                    // niri not running or invalid output
                }
            }
        }
    }
}
