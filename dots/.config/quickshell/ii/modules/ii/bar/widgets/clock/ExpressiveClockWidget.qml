import qs.modules.ii.bar.popups.clock
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool vertical: false
    property bool borderless: Config.options.bar.borderless
    property bool showDate: Config.options.bar.verbose
    property bool isMaterial: true
    readonly property bool is12h: /a/i.test(Config.options.time.format)

    implicitWidth: vertical ? Appearance.sizes.verticalBarWidth : (rowLoader.item?.implicitWidth ?? 0) + 8
    implicitHeight: vertical ? (colLoader.item?.implicitHeight ?? 0) + 8 : Appearance.sizes.baseBarHeight

    width: implicitWidth
    height: implicitHeight

    Loader {
        id: colLoader
        active: root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: ColumnLayout {
            id: layoutVert
            spacing: 2
            
            readonly property bool is12h: root.is12h
            readonly property string hours: is12h ? ("0" + (DateTime.clock.date.getHours() % 12 || 12)).slice(-2) : Qt.formatDateTime(DateTime.clock.date, "HH")
            readonly property string minutes: Qt.formatDateTime(DateTime.clock.date, "mm")
            readonly property string ampm: is12h ? Qt.formatDateTime(DateTime.clock.date, Config.options.time.format.includes("AP") ? "AP" : "ap").trim() : ""

            readonly property bool showAMPM: is12h && ampm.length > 0

            MaterialShape {
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: Appearance.sizes.verticalBarWidth - 8
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.normal
                    font.weight: Font.Black
                    color: Appearance.colors.colOnPrimary
                    text: layoutVert.hours
                    font.features: { "tnum": 1 }
                }
            }

            MaterialShape {
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colSecondaryContainer
                implicitSize: Appearance.sizes.verticalBarWidth - 8
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.normal
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: layoutVert.minutes
                    font.features: { "tnum": 1 }
                }
            }

            Rectangle {
                visible: !layoutVert.is12h && root.showDate && DateTime.dayNameShort !== ""
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 2
                implicitWidth: Appearance.sizes.verticalBarWidth - 8
                implicitHeight: 20
                color: Appearance.colors.colTertiaryContainer
                radius: Appearance.rounding.small
                StyledText {
                    anchors.centerIn: parent
                    text: DateTime.dayNameShort.toUpperCase()
                    font.pixelSize: 9
                    font.weight: Font.Black
                    color: Appearance.colors.colOnTertiaryContainer
                }
            }

            MaterialShape {
                visible: layoutVert.is12h && layoutVert.showAMPM
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Circle"
                color: Appearance.colors.colTertiaryContainer
                implicitSize: Appearance.sizes.verticalBarWidth - 12
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    font.weight: Font.Black
                    color: Appearance.colors.colOnTertiaryContainer
                    text: layoutVert.ampm
                }
            }

        }
    }

    Loader {
        id: rowLoader
        active: !root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: RowLayout {
            id: layoutHoriz
            spacing: 4
            
            readonly property bool is12h: root.is12h
            readonly property string hours: is12h ? ("0" + (DateTime.clock.date.getHours() % 12 || 12)).slice(-2) : Qt.formatDateTime(DateTime.clock.date, "HH")
            readonly property string minutes: Qt.formatDateTime(DateTime.clock.date, "mm")
            readonly property string ampm: is12h ? Qt.formatDateTime(DateTime.clock.date, Config.options.time.format.includes("AP") ? "AP" : "ap").trim() : ""

            readonly property bool showAMPM: is12h && ampm.length > 0

            MaterialShape {
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: Appearance.sizes.baseBarHeight - 8
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colOnPrimary
                    text: layoutHoriz.hours
                    font.features: { "tnum": 1 }
                }
            }

            StyledText {
                text: ":"
                color: Appearance.colors.colPrimary
                font.pixelSize: Appearance.font.pixelSize.large
                font.weight: Font.Black
                Layout.alignment: Qt.AlignVCenter
            }

            MaterialShape {
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colSecondaryContainer
                implicitSize: Appearance.sizes.baseBarHeight - 8
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: layoutHoriz.minutes
                    font.features: { "tnum": 1 }
                }
            }

            MaterialShape {
                visible: layoutHoriz.is12h && layoutHoriz.showAMPM
                shapeString: "Circle"
                color: Appearance.colors.colTertiaryContainer
                implicitSize: Appearance.sizes.baseBarHeight - 16
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    font.weight: Font.Light
                    color: Appearance.colors.colOnTertiaryContainer
                    text: layoutHoriz.ampm
                }
            }

            Rectangle {
                visible: !layoutHoriz.is12h && root.showDate && DateTime.dayNameShort !== ""
                implicitWidth: 32
                implicitHeight: Appearance.sizes.baseBarHeight - 16
                color: Appearance.colors.colTertiaryContainer
                radius: Appearance.rounding.small
                Layout.alignment: Qt.AlignVCenter
                StyledText {
                    anchors.centerIn: parent
                    text: DateTime.dayNameShort.toUpperCase()
                    font.pixelSize: 9
                    font.weight: Font.Black
                    color: Appearance.colors.colOnTertiaryContainer
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
