import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

ContentPage {
    id: root

    forceWidth: false
    property bool showBackButton: false
    signal goBack()

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
            text: Translation.tr("Commands")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        title: Translation.tr("Layout")
        icon: "table_rows_narrow"

        ConfigSwitch {
            buttonIcon: "table_rows_narrow"
            text: Translation.tr("Commands: sidebar tag layout")
            checked: Config.options.cheatsheet.commandsTagsSidebar
            onCheckedChanged: {
                Config.options.cheatsheet.commandsTagsSidebar = checked;
            }
        }
    }
}
