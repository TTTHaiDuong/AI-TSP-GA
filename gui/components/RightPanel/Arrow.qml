// components/ChartOverlay/ArrowItem.qml
import QtQuick
import ".."

// Arrow {
//     id: arrow
//     visible: true
//     anchors.fill: parent
//     lineWidth: 2
//     arrowSize: 10
//     z: 1000

//     Component.onCompleted: {
//         const pt1 = chartToCanvas(Qt.point(0.28, 0.87));
//         const pt2 = chartToCanvas(Qt.point(0.96, 0.38));
//         arrow.startPoint = pt1;
//         arrow.endPoint = pt2;
//     }

//     function chartToCanvas(point) {
//         const pos = routeMap.chart.mapToPosition(point, routeMap.chart.lineSeries);
//         // map từ chartView sang Canvas local coordinates
//         return Qt.point(pos.x - routeMap.chart.x, pos.y - routeMap.chart.y);
//     }
// }
Canvas {
    id: root
    property point startPoint
    property point endPoint
    property color color: "blue"
    property color crossColor: "red"
    property real lineWidth: 2
    property real arrowSize: 8
    property real padding: 5
    layer.enabled: true

    // Quản lý hiển thị: [startArrow, midCross, endArrow]
    property var states: [[false, false, true], [true, false, false], [true, false, true], [false, true, false]]
    property int currentState: 0

    anchors.fill: parent

    onStartPointChanged: requestPaint()
    onEndPointChanged: requestPaint()

    function drawArrow(ctx, point, angle) {
        ctx.beginPath();
        ctx.moveTo(point.x, point.y);
        ctx.lineTo(point.x + arrowSize * Math.cos(angle - Math.PI / 6), point.y + arrowSize * Math.sin(angle - Math.PI / 6));
        ctx.lineTo(point.x + arrowSize * Math.cos(angle + Math.PI / 6), point.y + arrowSize * Math.sin(angle + Math.PI / 6));
        ctx.closePath();
        ctx.fillStyle = color;
        ctx.fill();
    }

    function drawCross(ctx, startPt, endPt, size) {
        const midPt = Line.midPoint(startPt, endPt);
        const dx = endPt.x - startPt.x;
        const dy = endPt.y - startPt.y;
        const angle = Math.atan2(dy, dx);

        ctx.save();
        ctx.translate(midPt.x, midPt.y);
        ctx.rotate(angle);
        ctx.strokeStyle = crossColor;
        ctx.beginPath();
        ctx.moveTo(-size / 2, -size / 2);
        ctx.lineTo(size / 2, size / 2);
        ctx.moveTo(-size / 2, size / 2);
        ctx.lineTo(size / 2, -size / 2);
        ctx.stroke();
        ctx.restore();
    }

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();

        const vector = Vector.fromPoints(startPoint, endPoint);
        const angle = Vector.angle(vector);
        const unit = Vector.normalize(vector);
        const paddingVector = Vector.scale(unit, padding);
        const display = {
            startPoint: Vector.add(startPoint, paddingVector),
            endPoint: Vector.sub(endPoint, paddingVector)
        };

        // Đoạn thẳng
        ctx.strokeStyle = color;
        ctx.lineWidth = lineWidth;
        ctx.beginPath();
        ctx.moveTo(display.startPoint.x, display.startPoint.y);
        ctx.lineTo(display.endPoint.x, display.endPoint.y);
        ctx.stroke();

        if (states[currentState][0])
            drawArrow(ctx, display.startPoint, angle);
        if (states[currentState][1])
            drawCross(ctx, display.startPoint, display.endPoint, 20);
        if (states[currentState][2])
            drawArrow(ctx, display.endPoint, angle + Math.PI);
    }

    function checkClicked(x, y) {
        const line = {
            point1: startPoint,
            point2: endPoint
        };

        if (Line.distanceToPoint(line, {
            x,
            y
        }) <= lineWidth + 3)
            return true;
        return false;
    }

    MouseArea {
        anchors.fill: parent
        // acceptedButtons: Qt.NoButton
        onClicked: mouse => {
            if (root.checkClicked(mouse.x, mouse.y)) {
                root.currentState = (root.currentState + 1) % root.states.length;
                root.requestPaint();
            }
        }
    }
}
