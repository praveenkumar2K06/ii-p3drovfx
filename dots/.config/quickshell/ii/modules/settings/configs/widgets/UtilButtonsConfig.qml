import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
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
            text: Translation.tr("Utility Buttons")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        icon: "widgets"
        title: Translation.tr("Utility Buttons")

        ConfigSwitch {
            buttonIcon: "content_cut"
            text: Translation.tr("Show Screen Snip")
            checked: Config.options.bar.utilButtons.showScreenSnip
            onCheckedChanged: {
                Config.options.bar.utilButtons.showScreenSnip = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "colorize"
            text: Translation.tr("Show Color Picker")
            checked: Config.options.bar.utilButtons.showColorPicker
            onCheckedChanged: {
                Config.options.bar.utilButtons.showColorPicker = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "mic"
            text: Translation.tr("Show Mic Toggle")
            checked: Config.options.bar.utilButtons.showMicToggle
            onCheckedChanged: {
                Config.options.bar.utilButtons.showMicToggle = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "dark_mode"
            text: Translation.tr("Show Dark/Light Toggle")
            checked: Config.options.bar.utilButtons.showDarkModeToggle
            onCheckedChanged: {
                Config.options.bar.utilButtons.showDarkModeToggle = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "speed"
            text: Translation.tr("Show Performance Profile Toggle")
            checked: Config.options.bar.utilButtons.showPerformanceProfileToggle
            onCheckedChanged: {
                Config.options.bar.utilButtons.showPerformanceProfileToggle = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "videocam"
            text: Translation.tr("Show Record")
            checked: Config.options.bar.utilButtons.showScreenRecord
            onCheckedChanged: {
                Config.options.bar.utilButtons.showScreenRecord = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "imagesmode"
            text: Translation.tr("Show Wallpaper Selector")
            checked: Config.options.bar.utilButtons.showWallpaperToggle
            onCheckedChanged: {
                Config.options.bar.utilButtons.showWallpaperToggle = checked;
            }
        }
    }
}
