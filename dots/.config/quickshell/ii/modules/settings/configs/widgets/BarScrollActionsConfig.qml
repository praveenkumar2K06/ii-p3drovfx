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
                text: Translation.tr("Bar Scroll Actions")
                font.pixelSize: Appearance.font.pixelSize.large
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        ContentSection {
            title: Translation.tr("Scroll Actions")
            icon: "swap_vert"

            ConfigSwitch {
                buttonIcon: "volume_up"
                text: Translation.tr("Scroll to change volume")
                checked: Config.options.bar.enableVolumeScroll
                property bool readyForToggle: false
                Component.onCompleted: readyForToggle = true
                onCheckedChanged: {
                    if (!readyForToggle || !Config.ready)
                        return;
                    Config.options.bar.enableVolumeScroll = checked;
                }
            }
            ConfigSwitch {
                buttonIcon: "brightness_5"
                text: Translation.tr("Scroll to change brightness")
                checked: Config.options.bar.enableBrightnessScroll
                property bool readyForToggle: false
                Component.onCompleted: readyForToggle = true
                onCheckedChanged: {
                    if (!readyForToggle || !Config.ready)
                        return;
                    Config.options.bar.enableBrightnessScroll = checked;
                }
            }
        }
    }
}
