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
            text: Translation.tr("Amino Acids")
            font.pixelSize: Appearance.font.pixelSize.large
            font.family: Appearance.font.family.title
            color: Appearance.colors.colOnLayer0
        }
    }

    ContentSection {
        title: Translation.tr("Classification Scheme")
        icon: "palette"

        ContentSubsection {
            title: Translation.tr("Side chain classes")
            icon: "palette"
            Layout.fillWidth: true

            ConfigSelectionArray {
                currentValue: Config.options.cheatsheet.aminoAcidScheme
                onSelected: (newValue) => {
                    Config.options.cheatsheet.aminoAcidScheme = newValue;
                }
                options: [
                    {
                        displayName: Translation.tr("5 classes"),
                        value: "five"
                    },
                    {
                        displayName: Translation.tr("7 classes"),
                        value: "seven"
                    },
                    {
                        displayName: Translation.tr("4 classes"),
                        value: "four"
                    }
                ]
            }
        }
    }
}
