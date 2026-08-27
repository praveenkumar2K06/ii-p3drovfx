import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.modules.common
import qs.modules.common.widgets


Rectangle {
    id: dayPopRect

    width: 200
    height: columnLayout.implicitHeight + 2 * 8
    color: Appearance.m3colors.m3surfaceContainer
    radius: Appearance.rounding.normal + 4
    border.width: 2
    border.color: Appearance.colors.colLayer3

    ColumnLayout {
        id: columnLayout

        width: parent.width - 2 * 8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        StyledText {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            horizontalAlignment: Text.AlignHCenter
            text: Translation.tr("No events")
            color: Appearance.m3colors.m3outline
            wrapMode: Text.Wrap
        }
    }
}
