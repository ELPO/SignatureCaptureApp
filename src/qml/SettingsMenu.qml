import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

// Simple settings menu that allows the user to set some visual
// and behavioural options. It reads and writes on the adapter properties
Drawer {
    id: settingsMenu

    ColumnLayout {
        id: contentItem

        anchors.fill: parent

        RowLayout {

            Item {
                width: appStyle.margin / 2
            }

            Text {
                Layout.preferredHeight: appStyle.headerHeight - 6

                text: "Settings"

                verticalAlignment: Text.AlignVCenter
                font.family: appStyle.appFontFamily
                font.pixelSize: appStyle.appFontSize
                font.bold:  true
                color: appStyle.headerColor
            }
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.preferredWidth: parent.width
            color: appStyle.headerColor
        }

        RowLayout {

            Item {
                width: appStyle.margin / 2
            }

            Text {
                text: "Output"

                font.family: appStyle.appFontFamily
                font.pixelSize: 12
                color: appStyle.headerColor
            }

            Column {
                id: rButtons

                Layout.fillWidth: true

                RadioButton {
                    id: stdRb

                    text: "stdout"

                    Material.accent: appStyle.headerColor

                    onCheckedChanged: {
                        if (checked) {
                            postRb.checked = false
                        }

                        adapter.outputLocal = true
                    }

                    Component.onCompleted: checked = adapter.outputLocal
                }

                RowLayout {
                    spacing: 10

                    RadioButton {
                        id: postRb

                        text: "POST"

                        Material.accent: appStyle.headerColor

                        onCheckedChanged: {
                            if (checked) {
                                stdRb.checked = false
                            }

                            adapter.outputLocal = false
                        }

                        Component.onCompleted: checked = !adapter.outputLocal
                    }

                    TextField {
                        Layout.fillWidth: true

                        text: adapter.postUrl
                        horizontalAlignment: Text.AlignRight

                        visible: postRb.checked

                        font.family: appStyle.appFontFamily
                        font.pixelSize: 12

                        color: appStyle.headerColor
                        Material.accent: appStyle.headerColor

                        onActiveFocusChanged: {
                            if (focus) {
                                select(text.length, text.length)
                            }
                        }

                        onEditingFinished: adapter.postUrl = text
                    }
                }
            }
        }

        Item {
            Layout.preferredHeight: 15
        }

        RowLayout {
            Item {
                width: appStyle.margin / 2
            }

            Text {
                Layout.fillWidth: true
                text: "Pen Width"

                font.family: appStyle.appFontFamily
                font.pixelSize: 12
                color: appStyle.headerColor
            }

            SpinBox {
                Material.accent: appStyle.headerColor
                Material.foreground: appStyle.headerColor

                to: 6
                from: 4

                value: 4

                onValueChanged: {
                    adapter.lineWidth = value
                }

                Component.onCompleted: {
                    value = adapter.lineWidth
                }
            }
        }

        Item {
            Layout.preferredHeight: 15
        }

        RowLayout {

            Item {
                width: appStyle.margin / 2
            }

            Text {
                text: "Pen Color"

                font.family: appStyle.appFontFamily
                font.pixelSize: 12
                color: appStyle.headerColor
                Layout.fillWidth: true
            }

            Column {
                id: colorButtons

                RadioButton {
                    id: blackRb

                    text: "Black"

                    checked: true

                    Material.accent: appStyle.headerColor

                    onCheckedChanged: {
                        if (checked) {
                            appStyle.penColor = "black"
                        }
                    }
                }

                RadioButton {
                    id: redRb

                    text: "Red"

                    Material.accent: appStyle.headerColor

                    onCheckedChanged: {
                        if (checked) {
                            appStyle.penColor = "red"
                        }
                    }
                }

                RadioButton {
                    id: blueRb

                    text: "Blue"

                    Material.accent: appStyle.headerColor

                    onCheckedChanged: {
                        if (checked) {
                            appStyle.penColor = "blue"
                        }
                    }
                }
            }

            Item {
                width: appStyle.margin
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
