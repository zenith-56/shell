// Network service singleton.
// Polls NetworkManager via nmcli to expose connection state and signal icons.
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool connected: false         // Whether any network connection is active
    property bool wifi: false              // Whether connected via WiFi
    property string ssid: ""               // Current WiFi SSID
    property string ipAddress: ""          // Current IP address
    property int signalStrength: 0         // Signal strength percentage (0-100)
    property string state: "disconnected"  // Connection state string

    // Returns a Nerd Font glyph based on connection type and signal strength
    function statusIcon(): string {
        if (!connected) return "󰤭";                    // nf-md-wifi_off — no connection
        if (!wifi) return "";                        // nf-md-ethernet — wired connection
        if (signalStrength > 75) return "󰤨";           // nf-md-wifi — excellent signal
        if (signalStrength > 50) return "󰤥";           // nf-md-wifi — good signal
        if (signalStrength > 25) return "󰤢";           // nf-md-wifi — fair signal
        return "󰤟";                                    // nf-md-wifi — weak signal
    }

    // Polls every 10 seconds for network status changes
    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stateProc.exec(["nmcli", "-t", "-f", "STATE", "general"]);
            deviceProc.exec(["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]);
        }
    }

    // Reads overall NetworkManager state (connected/disconnected)
    Process {
        id: stateProc
        command: ["nmcli", "-t", "-f", "STATE", "general"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                var val = this.text.trim();
                root.connected = val === "connected";
                root.state = val;
            }
        }
    }

    // Reads device types and connection names to detect WiFi vs wired
    Process {
        id: deviceProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                var lines = this.text.trim().split("\n");
                root.wifi = false;
                root.ssid = "";

                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(":");
                    if (parts.length >= 3 && parts[1] === "connected") {
                        if (parts[0] === "wifi") {
                            root.wifi = true;
                            root.ssid = parts[2];
                        }
                    }
                }

                if (root.wifi) {
                    signalProc.exec(["nmcli", "-t", "-f", "IN-USE,SIGNAL", "device", "wifi", "list"]);
                } else {
                    root.signalStrength = 0;
                }
            }
        }
    }

    // Reads WiFi signal strength for the currently connected network
    Process {
        id: signalProc
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL", "device", "wifi", "list"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                var lines = this.text.trim().split("\n");
                root.signalStrength = 0;

                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(":");
                    if (parts.length >= 2 && parts[0] === "*") {
                        root.signalStrength = parseInt(parts[1]) || 0;
                        break;
                    }
                }
            }
        }
    }
}
