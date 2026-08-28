import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: subPageRoot
    anchors.fill: parent
    property bool showBackButton: false
    signal goBack()

    ContentPage {
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
                text: Translation.tr("Bar Popups")
                font.pixelSize: Appearance.font.pixelSize.large
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        ContentSection {
            title: Translation.tr("Popup services")
            icon: "open_in_new"

            ConfigSwitch {
                buttonIcon: "visibility"
                text: Translation.tr("Enable popups")
                checked: Config.options.bar.tooltips.enablePopups
                property bool readyForToggle: false
                Component.onCompleted: readyForToggle = true
                onCheckedChanged: {
                    if (!readyForToggle || !Config.ready)
                        return;
                    Config.options.bar.tooltips.enablePopups = checked;
                }
            }
            ConfigSwitch {
                enabled: Config.options.bar.tooltips.enablePopups
                buttonIcon: "colorize"
                text: Translation.tr("Enable color picker popup")
                checked: Config.options.bar.tooltips.enableColorPickerPopup
                onCheckedChanged: Config.options.bar.tooltips.enableColorPickerPopup = checked
            }
            ConfigSwitch {
                enabled: Config.options.bar.tooltips.enablePopups
                buttonIcon: "bluetooth"
                text: Translation.tr("Enable Bluetooth connection popup")
                checked: Config.options.bar.tooltips.enableBluetoothConnectionPopup
                onCheckedChanged: Config.options.bar.tooltips.enableBluetoothConnectionPopup = checked
            }
            ConfigSwitch {
                enabled: Config.options.bar.tooltips.enablePopups
                buttonIcon: "keyboard"
                text: Translation.tr("Enable keyboard layout transition popup")
                checked: Config.options.bar.tooltips.enableKeyboardLayoutTransitionPopup
                onCheckedChanged: Config.options.bar.tooltips.enableKeyboardLayoutTransitionPopup = checked
            }
        }
    }
}
