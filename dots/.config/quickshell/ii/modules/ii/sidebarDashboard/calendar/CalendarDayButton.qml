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
