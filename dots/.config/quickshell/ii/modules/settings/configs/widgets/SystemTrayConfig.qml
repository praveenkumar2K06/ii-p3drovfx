import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    id: root
    forceWidth: false

    signal goBack()

    // ── Back button row ───────────────────────────────────────────────────
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
            text: Translation.tr("System Tray")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        icon: "display_settings"
        title: Translation.tr("Tray Behavior & Style")

        ConfigSwitch {
            buttonIcon: "keep"
            text: Translation.tr("Make icons pinned by default")
            checked: Config.options.tray.invertPinnedItems
            onCheckedChanged: {
                Config.options.tray.invertPinnedItems = checked;
            }
        }

        ConfigSwitch {
            buttonIcon: "colorize"
            text: Translation.tr("Tint System Tray icons")
            checked: Config.options.tray.monochromeIcons
            onCheckedChanged: {
                Config.options.tray.monochromeIcons = checked;
            }
        }
    }
}
