import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2

// Just a styled button
Button {
    implicitWidth: 175
    implicitHeight: 46

    property color backgroundColor: "white"
    property color textColor: "black"

    Material.background: backgroundColor
    Material.foreground: textColor
}
