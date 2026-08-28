import qs.modules.ii.bar.popups.clock
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool showDate: Config.options.bar.verbose
    property bool isMaterial: Config.options.bar.styles.clock === "material"
    property bool vertical: Config.options.bar.vertical
    implicitWidth: root.isMaterial ? (rowLoader.item?.implicitWidth) : (rowLoader.item?.implicitWidth + rowLoader.item?.spacing * 10)
    implicitHeight: Appearance.sizes.baseBarHeight
    property color colText: dropArea.containsDrag ? Appearance.colors.colPrimary : rootItem.highlighted ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1

    Loader {
        id: rowLoader
        active: !root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: root.isMaterial ? rowMaterial : rowDefault

        Component {
            id: rowDefault
    
            RowLayout {
                id: rowLayout
                anchors.centerIn: parent
                spacing: 4

                StyledText {
                    font.pixelSize: Appearance.font.pixelSize.large
                    color: root.colText
                    text: DateTime.time
                }

                StyledText {
                    visible: root.showDate
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: root.colText
                    text: "•"
                }

                StyledText {
                    visible: root.showDate
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: root.colText
                    text: DateTime.longDate
                }
            }
        }

        Component {
            id: rowMaterial
            MaterialBarWidget {
                primaryComponent: timeComponent
                secondaryComponent: dateComponent
                showSecondary: Config.options.bar.clock.showSecondary
                secondaryOpposite: Config.options.bar.clock.secondaryOpposite
                swapPrimaryWithSecondary: Config.options.bar.clock.swapPrimaryWithSecondary
                showPrimary: Config.options.bar.clock.showPrimary

                Component {
                    id: timeComponent
                    StyledText {
                        id: timeText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        font.pixelSize: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.font.pixelSize.small : Appearance.font.pixelSize.smallie
                        color: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.colors.colPrimary : Appearance.colors.colOnPrimary

                        property var timeParts: DateTime.time.split(/[: ]/)
                        property string hours: timeParts[0] ?? "00"
                        property string minutes: timeParts[1] ?? "00"
                        property string ampm: timeParts[2] ?? ""

                        text: {
                            let baseTime = timeText.ampm !== "" 
                                            ? timeText.hours.padStart(2, "0") + ":" + timeText.minutes.padStart(2, "0")
                                            : DateTime.time;
                            let time = Config.options.bar.clock.showSeconds 
                                        ? baseTime + ":" + DateTime.seconds
                                        : baseTime;
                            return timeText.ampm !== "" ? time + " " + timeText.ampm : time;
                        }
                        font.features: { "tnum": 1 }
                        font.letterSpacing: -0.4
                    }
                }

                Component {
                    id: dateComponent
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        color: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.colors.colOnPrimary : Appearance.colors.colPrimary
                        text: DateTime.longDate
                        font.pixelSize: Config.options.bar.clock.swapPrimaryWithSecondary ? Appearance.font.pixelSize.smallie : Appearance.font.pixelSize.small
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
