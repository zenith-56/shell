// ColorAnimation primitive — wraps ColorAnimation with semantic easing.
// Uses slow-effects duration and bezier curve by default for smooth color transitions.
import QtQuick
import "../Commons"

ColorAnimation {
    id: root

    property int animType: Anim.DefaultEffects

    duration: {
        var d = Style.anim
        if (animType >= Anim.FastEffects && animType <= Anim.SlowEffects) {
            var effects = [d.fastEffects, d.defaultEffects, d.slowEffects]
            return effects[animType - Anim.FastEffects]
        }
        return d.defaultEffects
    }

    function _applyCurve() {
        var c = Style.anim.bezierEffects
        if (c && c.length === 4) {
            easing.type = Easing.BezierSpline
            easing.bezierCurve = c
        }
    }

    onAnimTypeChanged: _applyCurve()
    Component.onCompleted: _applyCurve()
}
