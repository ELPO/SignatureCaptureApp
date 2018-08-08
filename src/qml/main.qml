import QtQuick 2.10
import QtQuick.Window 2.10

Window {
    readonly property size fixedSize: Qt.size(480, 480)

    visible: true

    width: fixedSize.width
    height: fixedSize.height
    maximumWidth: fixedSize.width
    maximumHeight: fixedSize.height
    minimumWidth: fixedSize.width
    minimumHeight: fixedSize.height

    title: qsTr("Signature Capture")
}
