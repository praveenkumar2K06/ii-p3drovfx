import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

/**
 * Material 3 FAB.
 */
RippleButton {
    id: root
    property string iconText: "add"
    property bool expanded: false
    property real baseSize: 56
    property real iconSize: 26
    property real elementSpacing: 5
    implicitWidth: expanded ? (Math.max(contentRowLayout.implicitWidth + 10 * 2, baseSize)) : baseSize
    implicitHeight: baseSize

    readonly property bool sharpMode: Config.options.appearance.sharpMode
    buttonRadius: sharpMode ? 0 : baseSize / 14 * 4

    enum ButtonType {
        Primary,
        Secondary,
        Tertiary
    }

    property int type: FloatingActionButton.ButtonType.Primary

    property color colCustomBackground: {
        switch (root.type) {
        case FloatingActionButton.ButtonType.Secondary:
            return Appearance.colors.colSecondaryContainer
        case FloatingActionButton.ButtonType.Tertiary:
            return Appearance.colors.colTertiaryContainer
        default: // FloatingActionButton.ButtonType.Primary
            return Appearance.colors.colPrimaryContainer
        }
    }

    property color colCustomBackgroundHover: {
        switch (root.type) {
        case FloatingActionButton.ButtonType.Secondary:
            return Appearance.colors.colSecondaryContainerHover
        case FloatingActionButton.ButtonType.Tertiary:
            return Appearance.colors.colTertiaryContainerHover
        default: // FloatingActionButton.ButtonType.Primary
            return Appearance.colors.colPrimaryContainerHover
        }
    }

    property color colCustomRipple: {
        switch (root.type) {
        case FloatingActionButton.ButtonType.Secondary:
            return Appearance.colors.colSecondaryContainerActive
        case FloatingActionButton.ButtonType.Tertiary:
            return Appearance.colors.colTertiaryContainerActive
        default: // FloatingActionButton.ButtonType.Primary
            return Appearance.colors.colPrimaryContainerActive
        }
    }

    property color colCustomOnBackground: {
        switch (root.type) {
        case FloatingActionButton.ButtonType.Secondary:
            return Appearance.colors.colOnSecondaryContainer
        case FloatingActionButton.ButtonType.Tertiary:
            return Appearance.colors.colOnTertiaryContainer
        default: // FloatingActionButton.ButtonType.Primary
            return Appearance.colors.colOnPrimaryContainer
        }
    }
    
    colBackground: root.colCustomBackground
    colBackgroundHover: root.colCustomBackgroundHover
    colRipple: root.colCustomRipple
    property color colOnBackground: root.colCustomOnBackground
    contentItem: Row {
        id: contentRowLayout
        property real horizontalMargins: (root.baseSize - icon.width) / 2
        anchors {
            verticalCenter: parent ? parent.verticalCenter : undefined
            left: parent ? parent.left : undefined
            leftMargin: contentRowLayout.horizontalMargins
        }
        spacing: 0

        MaterialSymbol {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            iconSize: root.iconSize
            color: root.colOnBackground
            text: root.iconText
        }
        Loader {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.buttonText && root.buttonText.length > 0
            active: true
            sourceComponent: Revealer {
                visible: root.expanded || implicitWidth > 0
                reveal: root.expanded
                implicitWidth: reveal ? (buttonText.implicitWidth + root.elementSpacing + contentRowLayout.horizontalMargins) : 0
                implicitHeight: buttonText.implicitHeight
                StyledText {
                    id: buttonText
                    anchors {
                        left: parent.left
                        leftMargin: root.elementSpacing
                        verticalCenter: parent.verticalCenter
                    }
                    text: root.buttonText
                    color: Appearance.colors.colOnPrimaryContainer
                    font.pixelSize: 14
                    font.weight: 450
                }
            }
        }
    }
}
