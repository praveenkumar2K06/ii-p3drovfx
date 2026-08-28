import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.configs.ai
import qs.services

Item {
    id: root
    anchors.fill: parent
    property bool showBackButton: false
    signal goBack()

    ContentPage {
        anchors.fill: parent
        forceWidth: false

        RowLayout {
            visible: root.showBackButton
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
                text: Translation.tr("Usage & Cost")
                font.pixelSize: Appearance.font.pixelSize.large
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        ContentSection {
            icon: "monitoring"
            title: Translation.tr("Usage & Cost")
            tooltip: Translation.tr("Track token usage, request metrics, and costs across models.")
            customBackgroundColor: Appearance.colors.colLayer0

            AiUsageDashboard {
                Layout.fillWidth: true
            }
        }
    }
}
