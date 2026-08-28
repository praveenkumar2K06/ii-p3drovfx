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
            text: Translation.tr("Bluetooth Devices Popup")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        icon: "style"
        title: Translation.tr("Style & Layout")

        ContentSubsection {
            title: Translation.tr("Bluetooth devices layout")
            icon: "bluetooth"
            tooltip: Translation.tr("Choose the layout for the Bluetooth devices popup in the bar")
            ConfigSelectionArray {
                currentValue: Config.options.bar.bluetoothDevicesLayout
                onSelected: newValue => {
                    Config.options.bar.bluetoothDevicesLayout = newValue;
                }
                options: [
                    { displayName: Translation.tr("Classic"),    icon: "style",     value: "classic" },
                    { displayName: Translation.tr("Expressive"), icon: "fluid_med", value: "expressive" }
                ]
            }
        }
    }
}
