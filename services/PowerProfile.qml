// Power profile service singleton.
// Manages power profiles via native Quickshell UPower service.
pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    // Reactive active power profile string
    property string activeProfile: {
        switch (PowerProfiles.profile) {
            case PowerProfile.PowerSaver: return "power-saver";
            case PowerProfile.Balanced: return "balanced";
            case PowerProfile.Performance: return "performance";
            default: return "balanced";
        }
    }

    // Available power profiles
    readonly property var profiles: ["power-saver", "balanced", "performance"]

    // Change the system power profile safely
    function setProfile(profile: string): void {
        switch (profile) {
            case "power-saver":
                PowerProfiles.profile = PowerProfile.PowerSaver;
                break;
            case "balanced":
                PowerProfiles.profile = PowerProfile.Balanced;
                break;
            case "performance":
                if (PowerProfiles.hasPerformanceProfile) {
                    PowerProfiles.profile = PowerProfile.Performance;
                }
                break;
        }
    }
}