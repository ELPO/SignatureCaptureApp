import QtQuick 2.10

Canvas {
    id: signatureCanvas

    property point startPoint: Qt.point(0, 0)
    property point endPoint: Qt.point(0, 0)
    property double startTimestamp: 0
    property double endTimestamp: 0
    property int lineWidth: 4
    property int widthMargin: width / 12.0
    property bool clearing: true // so we paint the background detail the first time on Component creation

    anchors.fill: parent

    onPaint: {
        var ctx = getContext('2d');

        if (clearing) {
            clearing = false
            ctx.reset();

            ctx.fillStyle = appStyle.backgroundColor
            ctx.fillRect(0, 0, width, height)

            ctx.font = "20px sans-serif"
            ctx.fillStyle = "gray"
            ctx.fillText("x", widthMargin, height * 0.9 - 6)

            ctx.lineWidth = 1
            ctx.strokeStyle = "gray"

            ctx.beginPath()
            ctx.moveTo(widthMargin, height * 0.9)
            ctx.lineTo(width - widthMargin, height * 0.9)
            ctx.closePath()

            ctx.stroke()

            return
        }

        ctx.lineWidth = lineWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"
        ctx.strokeStyle = "black"
        ctx.fillStyle = "black"

        ctx.beginPath()
        ctx.moveTo(startPoint.x, startPoint.y)
        ctx.lineTo(endPoint.x, endPoint.y)
        ctx.closePath()

        ctx.stroke()

        startPoint = endPoint
    }

    onEndPointChanged: {
        appData.gesture.push(endPoint.x)
        appData.gesture.push(endPoint.y)
    }

    function clear() {
        clearing = true
        startPoint = Qt.point(0, 0)
        endPoint = Qt.point(0, 0)
        startTimestamp = 0
        endTimestamp = 0

        requestPaint()
    }

    function generateLineWidth() {
        var a = endPoint.x - startPoint.x
        var b = endPoint.y - startPoint.y
        var distance = Math.sqrt(a*a + b*b);

        if (distance < 2)
            lineWidth = 5
        else if (distance < 10)
            lineWidth = 4
        else if (distance < 25)
            lineWidth = 3
        else if (distance < 50)
            lineWidth = 2
        else lineWidth = 1
    }

    function getDuration() {
        return endTimestamp - startTimestamp
    }

    MouseArea {
        anchors.fill: parent

        onMouseXChanged: {
            endPoint = Qt.point(mouseX, mouseY)
            generateLineWidth()
            signatureCanvas.requestPaint()
            endTimestamp = Date.now()
        }

        onMouseYChanged: {
            endPoint = Qt.point(mouseX, mouseY)
            generateLineWidth()
            signatureCanvas.requestPaint()
            endTimestamp = Date.now()
        }

        onPressed: {
            if (startTimestamp === 0)
                startTimestamp = Date.now()

            startPoint = Qt.point(mouseX, mouseY)
        }
    }
}
