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
            text: Translation.tr("OLED Saver")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }
    ContentSection {
        icon: "brightness_1"
        title: Translation.tr("Blackout timing")

        StyledText {
            text: Translation.tr("Super + R blacks out the focused monitor. Esc, click, or the same shortcut dismisses it.")
            color: Appearance.colors.colOnLayer1
            opacity: 0.75
            font.pixelSize: Appearance.font.pixelSize.small
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            Layout.bottomMargin: 8
        }

        ConfigSpinBox {
            icon: "mouse"
            text: Translation.tr("Cursor hide delay (seconds)")
            value: Config.options.oledSaver.cursorHideDelay
            from: 1
            to: 60
            stepSize: 1
            onValueChanged: {
                Config.options.oledSaver.cursorHideDelay = value;
            }
            StyledToolTip {
                text: Translation.tr("How long after you stop moving the mouse before the cursor hides again")
            }
        }

        ConfigSpinBox {
            icon: "help"
            text: Translation.tr("Extra hint duration (seconds)")
            value: Config.options.oledSaver.hintExtraDelay
            from: 0
            to: 60
            stepSize: 1
            onValueChanged: {
                Config.options.oledSaver.hintExtraDelay = value;
            }
            StyledToolTip {
                text: Translation.tr("How much longer the \"Esc or click to exit\" hint stays up after the cursor hides")
            }
        }
    }
}
