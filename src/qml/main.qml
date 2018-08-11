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
        adapter.requestCompleted.connect(requestEnded)
    }

    QtObject {
        id: appStyle

        readonly property color backgroundColor: "#F1F2F4"
        readonly property color headerColor: "#3e5e6d"
        readonly property color textColor: "white"

        readonly property string appFontFamily: "Montserrat"
        readonly property int appFontSize: 16

        readonly property int headerHeight: appWindow.height / 8.0
        readonly property int margin: appWindow.width / 11.0 //assuming squared window
    }

    QtObject {
        id: appData

        property var gesture: []
        property int attempts: 0
        property int duration: 0
        property bool usingAntialising: true
    }

    function launchRequest() {
        busyIndicator.visible = true
        clearBtn.enabled = false
        payBtn.enabled = false
        signature.enabled = false
        adapter.pay(appData.gesture, appData.attempts, signature.getDuration())
    }

    function requestEnded() {
        busyIndicator.visible = false
        signature.clear()
        signature.enabled = true
        appData.gesture = []
        appData.attempts = 0
        clearBtn.enabled = true
        payBtn.enabled = true
    }

    SettingsMenu {
        id: settingsMenu

        width: 0.66 * appWindow.width
        height: appWindow.height
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: appStyle.backgroundColor

        ColumnLayout {
            anchors.fill: parent

            spacing: 0

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

                        //adapter.pay(appData.gesture, appData.attempts, signature.getDuration())

//                        signature.clear()
//                        appData.gesture = []
//                        appData.attempts = 0
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
