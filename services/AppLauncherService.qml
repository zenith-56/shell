// App launcher service singleton.
// Provides filtering and launching capabilities for desktop applications.
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property var filteredApplications: []
    property string filterText: ""

    // Applications to exclude (non-essential utilities)
    readonly property var excludedApps: [
        "btop", "htop", "top", "kill", "killall",
        "reboot", "shutdown", "logout", "lock",
        "systemctl", "journalctl", "dmesg",
        "lsblk", "lsusb", "lspci", "free"
    ]

    function isExcluded(app): bool {
        var nameLower = app.name.toLowerCase();
        for (var i = 0; i < excludedApps.length; i++) {
            if (nameLower.includes(excludedApps[i].toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    function launchApplication(app): void {
        app.execute();
    }
}