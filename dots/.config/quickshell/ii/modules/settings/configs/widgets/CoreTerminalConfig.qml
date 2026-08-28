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
            text: Translation.tr("Terminal Settings")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }
    ContentSection {
        title: Translation.tr("Terminal Settings")
        icon: "terminal"

        ConfigSwitch {
            buttonIcon: "dark_mode"
            text: Translation.tr("Force dark mode in terminal")
            checked: Config.options.appearance.wallpaperTheming.terminalGenerationProps.forceDarkMode
            onCheckedChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.forceDarkMode = checked;
            }
            StyledToolTip {
                text: Translation.tr("Ignored if terminal theming is not enabled in Colors & Themes")
            }
        }

        ConfigSpinBox {
            icon: "contrast"
            text: Translation.tr("Terminal: Harmony %")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmony * 100
            from: 0
            to: 100
            stepSize: 1
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmony = value / 100;
            }
        }

        ConfigSpinBox {
            icon: "tune"
            text: Translation.tr("Terminal: Harmonize threshold")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmonizeThreshold
            from: 0
            to: 100
            stepSize: 1
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.harmonizeThreshold = value;
            }
        }

        ConfigSpinBox {
            icon: "brightness_high"
            text: Translation.tr("Terminal: Foreground boost %")
            value: Config.options.appearance.wallpaperTheming.terminalGenerationProps.termFgBoost * 100
            from: 0
            to: 100
            stepSize: 1
            onValueChanged: {
                Config.options.appearance.wallpaperTheming.terminalGenerationProps.termFgBoost = value / 100;
            }
        }
    }
}
