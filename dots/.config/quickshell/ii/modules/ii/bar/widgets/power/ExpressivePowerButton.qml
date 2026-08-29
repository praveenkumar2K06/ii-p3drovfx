import QtQuick
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property bool vertical: false

    implicitWidth: vertical ? Appearance.sizes.verticalBarWidth - 8 : Appearance.sizes.baseBarHeight - 8
    implicitHeight: vertical ? Appearance.sizes.verticalBarWidth - 8 : Appearance.sizes.baseBarHeight - 8

    RippleButtonE {
        anchors.fill: parent
        buttonRadius: Appearance.rounding.full
        type: RippleButtonE.ButtonType.Filled
        onPressed: {
            GlobalStates.sessionOpen = !GlobalStates.sessionOpen
        }

        MaterialShapeWrappedMaterialSymbol {
            anchors.centerIn: parent
            text: "power_settings_new"
            iconSize: root.vertical ? 18 : Appearance.font.pixelSize.normal
            color: Appearance.colors.colOnPrimary
            colSymbol: Appearance.colors.colPrimary
            shape: MaterialShape.Shape.Cookie12Sided
            padding: root.vertical ? 5 : 2
        }
    }
}
