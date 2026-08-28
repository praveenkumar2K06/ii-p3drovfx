import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import qs.modules.ii.bar as Bar
import qs.modules.ii.bar.popups.clock

Item {
    id: root
    property bool isMaterial: Config.options.bar.styles.clock === "material"
    property bool vertical: Config.options.bar.vertical
    implicitHeight: (colLoader.item?.height ?? 0) + (root.isMaterial ? 0 : 10)
    implicitWidth: Appearance.sizes.verticalBarWidth

    Loader {
        id: colLoader
        active: root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: root.isMaterial ? colMaterial : colDefault

        Component {
            id: colDefault

            ColumnLayout {
                id: clockColumn
                anchors.centerIn: parent
                spacing: 0

                Repeater {
                    model: DateTime.time.split(/[: ]/)
                    delegate: StyledText {
                        required property string modelData
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: modelData.match(/am|pm/i) ? 
                            Appearance.font.pixelSize.smaller // Smaller "am"/"pm" text
                            : Appearance.font.pixelSize.large
                        color: rootItem.highlighted ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSurface
                        text: modelData.padStart(2, "0")
                    }
                }

            }
        }

        Component {
            id: colMaterial
            VerticalMaterialBarWidget {
                primaryComponent: timeColumnComponent
                secondaryComponent: dateColumnComponent
                showSecondary: Config.options.bar.clock.showSecondary
                secondaryOpposite: Config.options.bar.clock.secondaryOpposite
                swapPrimaryWithSecondary: Config.options.bar.clock.swapPrimaryWithSecondary
                showPrimary: Config.options.bar.clock.showPrimary

                Component {
                    id: timeColumnComponent
                    Column {
                        id: timeColumn
                        anchors.centerIn: parent
                        spacing: -2

                        property var timeParts: {
                            var parts = DateTime.time.split(/[: ]/);
                            if (Config.options.bar.clock.showSeconds) {
                                var secs = DateTime.seconds;
                                parts.splice(2, 0, secs);
                            }
                            return parts;
                        }

                        Repeater {
                            model: timeColumn.timeParts
                            delegate: StyledText {
                                required property string modelData
                                width: implicitWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: Appearance.font.family.main
                                font.features: { "tnum": 1 }
                                font.pixelSize: modelData.match(/am|pm/i)
                                    ? Appearance.font.pixelSize.smallest
                                    : Appearance.font.pixelSize.small
                                color: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.colors.colPrimary : Appearance.colors.colOnPrimary
                                text: modelData.padStart(2, "0")
                            }
                        }
                    }
                }

                Component {
                    id: dateColumnComponent
                    Column {
                        spacing: -4
                        anchors.horizontalCenter: parent.horizontalCenter

                        StyledText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.smallie
                            text: DateTime.dayNameShort
                            color: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.colors.colOnPrimary : Appearance.colors.colPrimary
                        }
                        StyledText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.font.pixelSize.smallest : Appearance.font.pixelSize.smaller
                            text: DateTime.shortDate
                            color: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.colors.colOnPrimary : Appearance.colors.colPrimary
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.bar.tooltips.clickToShow

        ClockWidgetPopup {
            compact: Config.options.bar.tooltips.compactPopups
            hoverTarget: mouseArea
        }
    }
}
