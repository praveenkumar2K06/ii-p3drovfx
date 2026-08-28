import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

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
            text: Translation.tr("Lyrics Providers")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        title: Translation.tr("Provider Services")
        icon: "lyrics"

        ConfigSwitch {
            buttonIcon: "mood"
            text: Translation.tr("Enable Genius lyrics service")
            checked: Config.options.lyricsService.enableGenius
            onCheckedChanged: {
                Config.options.lyricsService.enableGenius = checked;
            }
        }

        ConfigSwitch {
            buttonIcon: "library_books"
            text: Translation.tr("Enable LrcLib lyrics service")
            checked: Config.options.lyricsService.enableLrclib
            onCheckedChanged: {
                Config.options.lyricsService.enableLrclib = checked;
            }
        }

        ConfigSwitch {
            buttonIcon: "smart_display"
            text: Translation.tr("Enable YouTube Music lyrics")
            checked: Config.options.lyricsService.enableYtmusic
            onCheckedChanged: {
                Config.options.lyricsService.enableYtmusic = checked;
            }
            StyledToolTip {
                text: Translation.tr("Requires ytmusicapi installed in the venv (see ii-vynx setup). Fetches plain lyrics from YouTube Music.")
            }
        }
    }
}
