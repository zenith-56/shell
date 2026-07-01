// PopupCard — card container for popup content.
// Provides background, padding, and rounded corners.
import QtQuick
import "../Commons" as Commons

Rectangle {
    id: root

    default property alias content: contentItem.data
    property int padding: Commons.Style.spacing.lg

    color: Commons.Color.surface
    radius: Commons.Style.cornerRadius
    implicitWidth: Math.max(200, contentItem.implicitWidth + padding * 2)
    implicitHeight: Math.max(40, contentItem.implicitHeight + padding * 2)

    Behavior on color {
        ColorAnimation { duration: Commons.Style.anim.fastEffects; easing.type: Easing.BezierSpline; easing.bezierCurve: Commons.Style.anim.bezierEffects }
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: root.padding
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
