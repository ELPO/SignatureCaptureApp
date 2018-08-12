import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

Window {
    id: appWindow

    readonly property size fixedSize: Qt.size(480, 480)

    visible: true

    width: fixedSize.width
    height: fixedSize.height
    maximumWidth: fixedSize.width
    maximumHeight: fixedSize.height
    minimumWidth: fixedSize.width
    minimumHeight: fixedSize.height

    title: qsTr("Signature Capture")

    Component.onCompleted: {
        adapter.requestCompleted.connect(requestEnded) // When the request ends we reenable the UI
    }

    // App general style properties
    QtObject {
        id: appStyle

        readonly property color backgroundColor: "#F1F2F4"
        readonly property color headerColor: "#3e5e6d"
        readonly property color textColor: "white"
        property color penColor: "black"

        readonly property string appFontFamily: "Montserrat"
        readonly property int appFontSize: 16

        readonly property int headerHeight: appWindow.height / 8.0
        readonly property int margin: appWindow.width / 11.0 //assuming squared window
    }

    // App Data in the QML side
    QtObject {
        id: appData

        // signature coordinates in [[x1,y1,x2,y2...][xn,yn,xn+1,xn+2...]...] format.
        // Each subarray contains the data of a single stroke
        property var gesture: []
        property int attempts: 0 // number of 'clears' per signature
        property int duration: 0 // time between the first point and the payment
    }

    // We block the UI operations when the signature is being sent
    function launchRequest() {
        busyIndicator.visible = true
        clearBtn.enabled = false
        payBtn.enabled = false
        signature.enabled = false

        var plainGestureCoords = []

        for (var numStrokes = 0; numStrokes < appData.gesture.length; numStrokes++) {
            for (var i = 0; i < appData.gesture[numStrokes].length; i++) {
                plainGestureCoords.push(appData.gesture[numStrokes][i])
            }
        }

        adapter.pay(plainGestureCoords, appData.attempts, signature.getDuration())
    }

    // We reenable the UI when the request ends
    function requestEnded() {
        busyIndicator.visible = false
        signature.clear()
        signature.enabled = true
        appData.gesture = []
        appData.attempts = 0
        clearBtn.enabled = true
        payBtn.enabled = true
    }

    // Lateral Settings Menu
    SettingsMenu {
        id: settingsMenu

        property int storedWidth: 0
        property color storedColor: "black"

        width: 0.66 * appWindow.width
        height: appWindow.height

        onOpened: {
            storedColor = appStyle.penColor
            storedWidth = adapter.lineWidth
        }

        // If we have changed any pen options we need to repaint the signature
        onClosed: {
            if (storedWidth !== adapter.lineWidth ||
                storedColor !== appStyle.penColor)
                signature.updatePen()
        }
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: appStyle.backgroundColor

        ColumnLayout {
            anchors.fill: parent

            spacing: 0

            // Application header
            Pane {
                id: appHeader

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: appStyle.headerHeight
                Material.elevation: 4
                Material.background: appStyle.headerColor

                RowLayout {
                    anchors.fill: parent

                    Image {
                        id: settingsButton

                        source: "../../resources/settings.png"

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true

                            onHoveredChanged: {
                                if (containsMouse) {
                                    settingsButton.opacity = 0.7
                                }
                                else {
                                    settingsButton.opacity = 1
                                }
                            }

                            onClicked: {
                                settingsMenu.open()
                            }
                        }
                    }

                    Text {
                        id: textInfo

                        anchors.centerIn: parent

                        text: adapter.infoText
                        color: "white"
                        font.family: appStyle.appFontFamily
                        font.pixelSize: appStyle.appFontSize
                        font.bold: true
                    }

                    BusyIndicator {
                        id: busyIndicator

                        visible: false
                        anchors.verticalCenter: parent.verticalCenter

                        implicitWidth: 40
                        implicitHeight: 40

                        Material.accent: "white"
                    }
                }
            }

            Rectangle {
                id: signatureFrame

                Layout.fillHeight: true

                anchors.centerIn: parent
                Layout.preferredWidth: parent.width - appStyle.margin * 2

                SignatureCanvas {
                    id: signature

                    anchors.fill: parent
                }
            }

            RowLayout {
                id: buttons

                spacing: 0

                Item {
                    Layout.preferredWidth: appStyle.margin
                }

                TextButton {
                    id: clearBtn

                    anchors.verticalCenter: parent.verticalCenter

                    backgroundColor: appStyle.textColor
                    textColor: appStyle.headerColor

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

                TextButton {
                    id: payBtn

                    anchors.verticalCenter: parent.verticalCenter

                    textColor: appStyle.textColor
                    backgroundColor: appStyle.headerColor
                    text: "Pay"

                    onClicked: {
                        launchRequest()
                    }
                }

                Item {
                    Layout.preferredWidth: appStyle.margin
                }
            }

            Item {
                height: appStyle.margin - 10
            }
        }
    }
}
