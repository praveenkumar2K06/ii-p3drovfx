import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.modules.common
import qs.modules.common.widgets

RippleButton {
    id: button
    property string day
    property int isToday
    property bool bold

    property int gridRow: -1
    property int gridCol: -1
    property int entranceKey: 0

    property real _entranceOpacity: 0
    property real _entranceScale: 0.82
    property real _entranceTranslateX: -15
    property real _entranceTranslateY: -10
    property bool _entranceDone: false

    opacity: _entranceDone ? 1.0 : _entranceOpacity
    scale: _entranceDone ? 1.0 : _entranceScale
    transform: Translate {
        x: button._entranceDone ? 0 : button._entranceTranslateX
        y: button._entranceDone ? 0 : button._entranceTranslateY
    }

    function resetAndAnimate() {
        if (gridRow < 0 || gridCol < 0) {
            _entranceDone = true;
            return;
        }
        _entranceDone = false;
        _entranceOpacity = 0;
        _entranceScale = 0.82;
        _entranceTranslateX = -15;
        _entranceTranslateY = -10;
        Qt.callLater(function() {
            entranceAnim.start();
        });
    }

    onEntranceKeyChanged: resetAndAnimate()
    Component.onCompleted: resetAndAnimate()

    SequentialAnimation {
        id: entranceAnim
        PauseAnimation { duration: Math.max(0, Math.round(((button.gridRow ?? 0) + (button.gridCol ?? 0)) * 28)) }
        ParallelAnimation {
            NumberAnimation { target: button; property: "_entranceOpacity"; from: 0; to: 1; duration: 220; easing.type: Easing.OutCubic }
            NumberAnimation { target: button; property: "_entranceScale"; from: 0.82; to: 1.0; duration: 280; easing.type: Easing.OutBack }
            NumberAnimation { target: button; property: "_entranceTranslateX"; from: -15; to: 0; duration: 260; easing.type: Easing.OutCubic }
            NumberAnimation { target: button; property: "_entranceTranslateY"; from: -10; to: 0; duration: 260; easing.type: Easing.OutCubic }
        }
        PropertyAction { target: button; property: "_entranceDone"; value: true }
    }
    
    Layout.fillWidth: false
    Layout.fillHeight: false
    // The grid is the tallest thing in the sidebar's bottom group, so the cell
    // shrinks with the space the calendar is given instead of being clipped.
    property real cellSize: 38
    implicitWidth: cellSize
    implicitHeight: cellSize
    toggled: (isToday == 1)
    buttonRadius: Appearance.rounding.small
    
    StyledText {
        anchors.centerIn: parent
        text: day
        horizontalAlignment: Text.AlignHCenter
        font.weight: bold ? Font.DemiBold : Font.Normal
        color: (isToday == 1) ? Appearance.m3colors.m3onPrimary : (isToday == 0) ? Appearance.colors.colOnLayer1 : Appearance.colors.colOutlineVariant
    }
}
