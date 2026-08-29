import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

RippleButton {
    id: root

    enum ButtonType {
        Text,
        Tonal,
        Filled,
        FilledTonal,
        Tertiary,
        Error,
        ErrorTonal
    }

    property int iconSize: Appearance.font.pixelSize.normal
    property real iconFilled: 0
    property string materialIcon: ""

    property alias buttonText: root.text

    property int type: RippleButtonE.ButtonType.Text

    property color colCustomText: {
        switch (root.type) {
        case RippleButtonE.ButtonType.Filled:
            return root.checked ? Appearance.colors.colOnSecondaryContainer 
                                : Appearance.colors.colOnPrimary
        case RippleButtonE.ButtonType.FilledTonal:
            return Appearance.colors.colOnPrimaryContainer
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colOnSecondaryContainer
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colOnError
        case RippleButtonE.ButtonType.ErrorTonal:
            return Appearance.colors.colOnErrorContainer
        case RippleButtonE.ButtonType.Tertiary:
            return Appearance.colors.colOnTertiary
        default: // RippleButtonE.ButtonType.Text
            return Appearance.colors.colPrimary
        }
    }

    property color colCustomBackground: {
        switch (root.type) {
        case RippleButtonE.ButtonType.Filled:
            if (root.down) return Appearance.colors.colPrimaryActive
            if (root.hovered) return Appearance.colors.colPrimaryHover
            return Appearance.colors.colPrimary

        case RippleButtonE.ButtonType.FilledTonal:
            if (root.down) return Appearance.colors.colPrimaryContainerActive
            if (root.hovered) return Appearance.colors.colPrimaryContainerHover
            return Appearance.colors.colPrimaryContainer

        case RippleButtonE.ButtonType.Tonal:
            if (root.down) return Appearance.colors.colSecondaryContainerActive
            if (root.hovered) return Appearance.colors.colSecondaryContainerHover
            return Appearance.colors.colSecondaryContainer

        case RippleButtonE.ButtonType.Error:
            if (root.down) return Appearance.colors.colErrorActive
            if (root.hovered) return Appearance.colors.colErrorHover
            return Appearance.colors.colError

        case RippleButtonE.ButtonType.ErrorTonal:
            if (root.down) return Appearance.colors.colErrorContainerActive
            if (root.hovered) return Appearance.colors.colErrorContainerHover
            return Appearance.colors.colErrorContainer
        
        case RippleButtonE.ButtonType.Tertiary:
            if (root.down) return Appearance.colors.colTertiaryActive
            if (root.hovered) return Appearance.colors.colTertiaryHover
            return Appearance.colors.colTertiary

        default: // Text Button
            if (root.down) return Appearance.colors.colSecondaryContainerActive
            if (root.hovered) return Appearance.colors.colSecondaryContainerHover
            if (root.checked) return Appearance.colors.colSecondaryContainer
            return "transparent"
        }
    }

    property color colCustomHover: {
        switch (root.type) {
        case RippleButtonE.ButtonType.Filled:
            return Appearance.colors.colPrimaryHover
        case RippleButtonE.ButtonType.FilledTonal:
            return Appearance.colors.colPrimaryContainerHover
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colSecondaryContainerHover
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colErrorHover
        case RippleButtonE.ButtonType.ErrorTonal:
            return Appearance.colors.colErrorContainerHover
        case RippleButtonE.ButtonType.Tertiary:
            return Appearance.colors.colTertiaryHover
        default: // RippleButtonE.ButtonType.Text
            return Appearance.colors.colSecondaryContainerHover
        }
    }

    property color colCustomRipple: {
        switch (root.type) {
        case RippleButtonE.ButtonType.Filled:
            return Appearance.colors.colPrimaryActive
        case RippleButtonE.ButtonType.FilledTonal:
            return Appearance.colors.colPrimaryContainerActive
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colSecondaryContainerActive
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colErrorActive
        case RippleButtonE.ButtonType.ErrorTonal:
            return Appearance.colors.colErrorContainerActive
        case RippleButtonE.ButtonType.Tertiary:
            return Appearance.colors.colTertiaryActive
        default: // RippleButtonE.ButtonType.Text
            return Appearance.colors.colOnSurfaceVariant
        }
    }
    
    buttonRadius: Appearance.rounding.full
    buttonTextColor: root.colCustomText
    colBackground: root.colCustomBackground
    colBackgroundHover: root.colCustomHover
    colRipple: root.colCustomRipple

    contentItem: RowLayout {
        anchors.centerIn: parent
        Layout.alignment: Qt.AlignCenter
        spacing: 8

        Loader {
            id: iconLoader
            sourceComponent: iconComp
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            visible: root.materialIcon !== ""
        }

        Component {
            id: iconComp
            MaterialSymbol {
                visible: root.materialIcon !== ""
                text: root.materialIcon
                iconSize: root.iconSize
                fill: root.iconFilled
                color: root.colCustomText
            }
        }

        Loader {
            id: textLoader
            sourceComponent: textComp
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            visible: root.buttonText !== ""
        }

        Component {
            id: textComp
            StyledText {
                visible: root.text !== ""
                Layout.alignment: Qt.AlignVCenter

                text: root.buttonText
                color: root.colCustomText

                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Font.Medium

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
            }
        }
    }
}