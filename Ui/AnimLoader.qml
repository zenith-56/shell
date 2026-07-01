// Crossfade Loader — smoothly transitions between content on source change.
import QtQuick
import "../Commons"

Item {
    id: root

    property url source: ""
    property alias item: loader.item

    Loader {
        id: loader
        anchors.fill: parent
        source: root.source
        opacity: 0

        onSourceChanged: {
            opacity = 0
            if (status === Loader.Ready) {
                fadeIn.start()
            }
        }

        onLoaded: fadeIn.start()
    }

    Anim {
        id: fadeIn
        target: loader
        property: "opacity"
        from: 0
        to: 1
        type: Anim.DefaultEffects
    }
}
