import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

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

    QtObject {
        id: appStyle

        readonly property color backgroundColor: "#F1F2F4"
    }

    QtObject {
        id: appData

        property var gesture: []
        property int attempts: 0
        property int duration: 0
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: appStyle.backgroundColor

        Rectangle {
            id: signatureFrame

            anchors.fill: parent
            anchors.margins: parent.width / 11.0 // assuming a squared window

            SignatureCanvas {
                id: signature

                width: parent.width
            }
        }

        RowLayout {
            id: buttons

            anchors.top: signatureFrame.bottom
            width: parent.width

            Item {
                Layout.preferredWidth: parent.width / 11.0
            }

            Button {
                text: "Clear"

                onClicked: {
                    signature.clear()
                    appData.gesture = []
                    appData.attempts++
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: "Pay"

                onClicked: {
                    adapter.pay(appData.gesture, appData.attempts, signature.getDuration())

                    signature.clear()
                    appData.gesture = []
                    appData.attempts = 0
                }
            }

            Item {
                Layout.preferredWidth: parent.width / 11.0
            }
        }
    }
}
