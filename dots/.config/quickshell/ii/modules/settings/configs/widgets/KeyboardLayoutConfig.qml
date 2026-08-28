import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

ContentPage {
    id: root

    signal goBack()

    forceWidth: false

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
            text: Translation.tr("Keyboard Layout")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }

    }

    ContentSection {
        icon: "keyboard"
        title: Translation.tr("Keyboard Layout")

        ConfigSwitch {
            buttonIcon: "uppercase"
            text: Translation.tr("Uppercase layout abbreviation")
            checked: Config.options.bar.keyboardLayout.uppercaseLayout
            onCheckedChanged: {
                Config.options.bar.keyboardLayout.uppercaseLayout = checked;
            }
        }

    }

    MaterialWidgetLayoutSection {
        enabled: Config.options.bar.styles.keyboard === "material"
        config: Config.options.bar.keyboardLayout
    }

}
