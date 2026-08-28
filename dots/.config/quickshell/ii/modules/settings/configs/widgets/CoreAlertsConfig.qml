import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

ContentPage {
    id: root
    forceWidth: false
    signal goBack()

    RowLayout {
        spacing: Appearance.sizes.elevationMargin


                RippleButtonE {
            implicitWidth: Appearance.sizes.elevationMargin * 4
            implicitHeight: implicitWidth
            type: RippleButtonE.ButtonType.Tonal
            materialIcon: "arrow_back"
            iconSize: Appearance.font.pixelSize.large
            onClicked: root.goBack()
        }

        StyledText {
            text: Translation.tr("Interactive Alerts")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }
    ContentSection {
        icon: "notifications_active"
        title: Translation.tr("Interactive Alerts")

        ShortcutBox {
            Layout.fillWidth: true
            value: Translation.tr("Alert sounds moved to the Sounds page")
            targetPageIndex: 18
            targetSectionTitle: Translation.tr("Events")
            materialIcon: "volume_up"
        }
    }
}
