// Network service singleton.
// Uses Quickshell.Networking native API for fully reactive state.
pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    // Reactive: Find the first WiFi device in the system
    readonly property var wifiDevice: {
        var devs = Networking.devices.values;
        if (!devs) return null;
        for (var i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi) return devs[i];
        }
        return null;
    }

    // Reactive connection properties
    readonly property bool connected: wifiDevice ? wifiDevice.connected : false
    readonly property bool wifi: wifiDevice !== null
    readonly property bool wifiEnabled: Networking.wifiEnabled

    // Current connected network helper
    readonly property var connectedNetwork: {
        if (!wifiDevice) return null;
        var nets = wifiDevice.networks.values;
        if (!nets) return null;
        for (var i = 0; i < nets.length; i++) {
            if (nets[i].connected) return nets[i];
        }
        return null;
    }

    // Current SSID and signal strength
    readonly property string ssid: connectedNetwork ? (connectedNetwork.name || "") : ""
    readonly property int signalStrength: connectedNetwork ? Math.round((connectedNetwork.signalStrength || 0) * 100) : 0

    // Reactive list of available networks, sorted by signal strength
    readonly property var availableNetworks: {
        if (!wifiDevice) return [];
        var nets = wifiDevice.networks.values;
        if (!nets) return [];
        var networks = [];
        for (var i = 0; i < nets.length; i++) {
            var n = nets[i];
            networks.push({
                ssid: n.name,
                signal: Math.round((n.signalStrength || 0) * 100),
                security: WifiSecurityType.toString(n.security),
                connected: n.connected,
                known: n.known,
                networkObj: n
            });
        }
        networks.sort(function(a, b) { return b.signal - a.signal; });
        return networks;
    }

    // Toggle WiFi state
    function toggleWifi(): void {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    // Enable network scanning
    function scanNetworks(): void {
        if (wifiDevice) {
            wifiDevice.scannerEnabled = true;
        }
    }

    // Connect to a network
    function connect(ssid: string, password: string): void {
        var nets = availableNetworks;
        for (var i = 0; i < nets.length; i++) {
            if (nets[i].ssid === ssid) {
                var net = nets[i].networkObj;
                if (password.length > 0 && net instanceof WifiNetwork) {
                    net.connectWithPsk(password);
                } else {
                    net.connect();
                }
                return;
            }
        }
    }

    // Disconnect from the current network
    function disconnect(): void {
        if (wifiDevice) {
            wifiDevice.disconnect();
        }
    }
}
