import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: subPageRoot
    anchors.fill: parent

    property bool showBackButton: false
    signal goBack()

    ContentPage {
        id: page
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
                text: Translation.tr("Wallpaper Theming & Matugen")
                font.pixelSize: Appearance.font.pixelSize.large
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        ContentSection {
            title: Translation.tr("Application Theming")
            icon: "wallpaper"

            ConfigSwitch {
                buttonIcon: "desktop_windows"
                text: Translation.tr("Shell & utilities")
                checked: Config.options.appearance.wallpaperTheming.enableAppsAndShell
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableAppsAndShell = checked;
                }
            }

            ConfigSwitch {
                buttonIcon: "widgets"
                text: Translation.tr("Qt apps")
                checked: Config.options.appearance.wallpaperTheming.enableQtApps
                enabled: Config.options.appearance.wallpaperTheming.enableAppsAndShell
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableQtApps = checked;
                }
                StyledToolTip {
                    text: Translation.tr("Shell & utilities theming must also be enabled")
                }
            }

            ConfigSwitch {
                buttonIcon: "terminal"
                text: Translation.tr("Terminal")
                checked: Config.options.appearance.wallpaperTheming.enableTerminal
                enabled: Config.options.appearance.wallpaperTheming.enableAppsAndShell
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableTerminal = checked;
                }
                StyledToolTip {
                    text: Translation.tr("Shell & utilities theming must also be enabled")
                }
            }
        }
    }
}
