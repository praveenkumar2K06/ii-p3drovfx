import qs.modules.common
import QtQuick

StyledText {
    id: root
    property real iconSize: Appearance?.font.pixelSize.normal ?? 16
    property real fill: 0
    // Keep the font on a complete outlined or filled glyph. Fractional FILL
    // values during animation can drop internal paths in Qt's variable-font
    // renderer after a parent scale transform.
    readonly property real truncatedFill: fill.toFixed(1)

    // QtRendering can omit contours from filled variable-font glyphs (notably
    // `devices`) at small sizes. NativeRendering uses the font engine's glyph
    // rasterizer and preserves the complete FILL outline.
    renderType: Text.NativeRendering
    // antialiasing: true
    // smooth: true
    horizontalAlignment: Text.AlignHCenter

    font {
        hintingPreference: Font.PreferNoHinting
        family: Appearance?.font.family.iconMaterial ?? "Material Symbols Rounded"
        pixelSize: iconSize
        weight: Font.Normal + (Font.DemiBold - Font.Normal) * truncatedFill
        variableAxes: ({
                "FILL": truncatedFill,
                // "wght": 400,
                // "opsz": Math.max(20, Math.min(48, iconSize))
                "opsz": iconSize,
            })
    }

    Behavior on fill {
        NumberAnimation {
            duration: Appearance?.animation.elementMoveFast.duration ?? 200
            easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
            easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
        }
    }
}

