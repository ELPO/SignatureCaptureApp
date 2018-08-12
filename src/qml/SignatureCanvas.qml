import QtQuick 2.10

Canvas {
    id: signatureCanvas

    property point startPoint: Qt.point(0, 0)
    property point endPoint: Qt.point(0, 0)
    property double startTimestamp: 0
    property double endTimestamp: 0
    property int lineWidth: adapter.lineWidth
    property int widthMargin: width / 12.0
    property bool clearing: true // We paint the background detail the first time on Component creation
    property bool updating: false

    anchors.fill: parent

    onPaint: {
        var ctx = getContext('2d');

        // If we are clearing the canvas we need to clear everything and the repaint the background detail
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

        // If we are updating the canvas witha new pen style we need to clear everything, paint the background
        // detail and then repaint all the points recalculating the lineWidth of each segment. This could be
        // optimized in future iterations.
        if (updating) {
            updating = false

            // clear
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

            // Repaint the signature
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.strokeStyle = appStyle.penColor
            ctx.fillStyle = appStyle.penColor

            for (var numStrokes = 0; numStrokes < appData.gesture.length; numStrokes++) {
                for (var i = 0; i < appData.gesture[numStrokes].length -2; i+= 2) {
                    ctx.beginPath()

                    ctx.moveTo(appData.gesture[numStrokes][i], appData.gesture[numStrokes][i+1])
                    ctx.lineTo(appData.gesture[numStrokes][i+2], appData.gesture[numStrokes][i+3])
                    generateLineWidth(appData.gesture[numStrokes][i], appData.gesture[numStrokes][i+1],
                                      appData.gesture[numStrokes][i+2], appData.gesture[numStrokes][i+3])

                    ctx.lineWidth = lineWidth
                    ctx.stroke()
                }
            }

            return
        }

        if (appData.gesture.length === 0) {
            clear()
        }

        // If we are drawing we just paint the new segment
        ctx.lineWidth = lineWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"
        ctx.strokeStyle = appStyle.penColor

        ctx.beginPath()
        ctx.moveTo(startPoint.x, startPoint.y)
        ctx.lineTo(endPoint.x, endPoint.y)
        ctx.closePath()

        ctx.stroke()

        startPoint = endPoint
    }

    // this slot fills the signature data with the new points
    onEndPointChanged: {
        appData.gesture[appData.gesture.length-1].push(endPoint.x)
        appData.gesture[appData.gesture.length-1].push(endPoint.y)
    }

    // clear canvas function
    function clear() {
        clearing = true
        startPoint = Qt.point(0, 0)
        endPoint = Qt.point(0, 0)
        startTimestamp = 0
        endTimestamp = 0

        requestPaint()
    }

    // Update canvas function. Called when settings of the pen change.
    function updatePen() {
        updating = true
        requestPaint()
    }

    // We calculate the width of the line. Thicker lines for
    // slower speed (closer points) and viceversa.
    function generateLineWidth(x1, y1, x2, y2) {
        var a = x2 - x1
        var b = y2 - y1
        var distance = Math.sqrt(a*a + b*b);

        if (distance < 2)
            lineWidth = adapter.lineWidth + 2
        else if (distance < 10)
            lineWidth = adapter.lineWidth + 1
        else if (distance < 25)
            lineWidth = adapter.lineWidth
        else if (distance < 50)
            lineWidth = adapter.lineWidth - 1
        else
            lineWidth = adapter.lineWidth - 2
    }

    function getDuration() {
        return endTimestamp - startTimestamp
    }

    // This mouse area tracks the timestamps and the coordinates of the user clicks on the canvas
    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.CrossCursor

        onMouseXChanged: {
            endPoint = Qt.point(mouseX, mouseY)
            generateLineWidth(startPoint.x, startPoint.y, endPoint.x, endPoint.y)
            signatureCanvas.requestPaint()
            endTimestamp = Date.now()
        }

        onMouseYChanged: {
            endPoint = Qt.point(mouseX, mouseY)
            generateLineWidth(startPoint.x, startPoint.y, endPoint.x, endPoint.y)
            signatureCanvas.requestPaint()
            endTimestamp = Date.now()
        }

        onPressed: {
            if (startTimestamp === 0)
                startTimestamp = Date.now()

            startPoint = Qt.point(mouseX, mouseY)
            appData.gesture.push([])
        }
    }
}
