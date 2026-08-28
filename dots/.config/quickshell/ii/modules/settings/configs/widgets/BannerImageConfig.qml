import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.configs.widgets

Item {
    id: subPageRoot
    anchors.fill: parent

    property bool showBackButton: false
    signal goBack()

    ContentPage {
        id: root
        anchors.fill: parent
        forceWidth: false

        RowLayout {
            visible: subPageRoot.showBackButton
            spacing: Appearance.sizes.elevationMargin

            RippleButtonE {
                implicitWidth: Appearance.sizes.elevationMargin * 4
                implicitHeight: implicitWidth
                type: RippleButtonE.ButtonType.Tonal
                materialIcon: "arrow_back"
                iconSize: Appearance.font.pixelSize.large
                onClicked: subPageRoot.goBack()
            }

            StyledText {
                text: Translation.tr("Banner Image Settings")
                font.pixelSize: Appearance.font.pixelSize.large
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        ContentSection {
            title: Translation.tr("Banner Image")
            icon: "wallpaper"

            RowLayout {
                Layout.fillWidth: true

                ConfigBannerSelector {
                    text: Translation.tr("Banner Image Selector")
                }
            }
        }
    }
}
