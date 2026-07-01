// Animation primitive — wraps NumberAnimation with semantic types.
// Duration and easing driven by configurable tokens from Style.anim.
import QtQuick
import "../Commons"

NumberAnimation {
    id: root

    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial,
        FastEffects,
        DefaultEffects,
        SlowEffects
    }

    property int type: Anim.DefaultSpatial

    duration: {
        var d = Style.anim
        if (type === Anim.FastSpatial) return d.fastSpatial
        if (type === Anim.DefaultSpatial) return d.defaultSpatial
        if (type === Anim.SlowSpatial) return d.slowSpatial
        if (type === Anim.FastEffects) return d.fastEffects
        if (type === Anim.DefaultEffects) return d.defaultEffects
        if (type === Anim.SlowEffects) return d.slowEffects
        var durations = [d.small, d.normal, d.large, d.extraLarge]
        return durations[type % 4]
    }

    function _resolveCurve(t) {
        var a = Style.anim
        if (t >= Anim.FastSpatial && t <= Anim.SlowSpatial) return a.bezierSpatial
        if (t >= Anim.FastEffects && t <= Anim.SlowEffects) return a.bezierEffects
        if (t >= Anim.EmphasizedSmall && t <= Anim.EmphasizedExtraLarge) return a.bezierEmphasized
        return a.bezierStandard
    }

    function _applyCurve() {
        var c = _resolveCurve(type)
        if (c && c.length === 4) {
            easing.type = Easing.BezierSpline
            easing.bezierCurve = c
        }
    }

    onTypeChanged: _applyCurve()
    Component.onCompleted: _applyCurve()
}
