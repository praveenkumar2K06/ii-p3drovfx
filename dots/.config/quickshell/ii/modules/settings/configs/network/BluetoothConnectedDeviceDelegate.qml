pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.settings.configs.network

Item {
    id: root

    required property BluetoothDevice modelData
    required property int index
    property bool isFirst: false
    property bool isLast: false

    readonly property BluetoothDevice device: modelData

    Layout.fillWidth: true
    implicitHeight: currentCard ? currentCard.implicitHeight : 58

    property var currentCard: genericRowLoader.item

    BluetoothDeviceRow {
        device: root.device
        isFirst: root.isFirst
        isLast: root.isLast
    }
}
