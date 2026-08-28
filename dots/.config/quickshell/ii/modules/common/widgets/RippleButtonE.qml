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
        Error
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
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colOnSecondaryContainer
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colOnError
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

        case RippleButtonE.ButtonType.Tonal:
            if (root.down) return Appearance.colors.colSecondaryContainerActive
            if (root.hovered) return Appearance.colors.colSecondaryContainerHover
            return Appearance.colors.colSecondaryContainer

        case RippleButtonE.ButtonType.Error:
            if (root.down) return Appearance.colors.colErrorActive
            if (root.hovered) return Appearance.colors.colErrorHover
            return Appearance.colors.colError

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
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colSecondaryContainerHover
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colErrorHover
        default: // RippleButtonE.ButtonType.Text
            return Appearance.colors.colSecondaryContainerHover
        }
    }

    property color colCustomRipple: {
        switch (root.type) {
        case RippleButtonE.ButtonType.Filled:
            return Appearance.colors.colPrimaryContainerActive
        case RippleButtonE.ButtonType.Tonal:
            return Appearance.colors.colSecondaryContainerActive
        case RippleButtonE.ButtonType.Error:
            return Appearance.colors.colErrorContainerActive
        default: // RippleButtonE.ButtonType.Text
            return Appearance.colors.colOnSurfaceVariant
        }
    }
    
    topLeftRadius: Appearance.rounding.full
    topRightRadius: Appearance.rounding.full
    bottomLeftRadius: Appearance.rounding.full
    bottomRightRadius: Appearance.rounding.full
    buttonTextColor: root.colCustomText
    colBackground: root.colCustomBackground
    colBackgroundHover: root.colCustomHover
    colRipple: root.colCustomRipple

    contentItem: RowLayout {
        anchors.centerIn: parent
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