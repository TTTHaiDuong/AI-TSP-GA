import QtCharts
import QtQuick
import ".."

ChartView {
    id: root
    margins.top: 5
    margins.bottom: 15
    margins.left: 5
    margins.right: 25
    legend.visible: false
    antialiasing: true
    smooth: true
    backgroundColor: "#f6f6f6ff"

    property real padding: 1.0
    property color pointColor: "red"
    property color lineColor: "red"
    property alias axisX: axisX
    property alias axisY: axisY
    property alias lineSeries: lineSeries
    property alias pointSeries: pointSeries

    ValueAxis {
        id: axisX
        max: 100
    }

    ValueAxis {
        id: axisY
        max: 50
    }

    LineSeries {
        id: lineSeries
        axisX: axisX
        axisY: axisY
        color: root.lineColor
        width: 2

        // onPointAdded: index => root._rescaleArea(at(index))
    }

    ScatterSeries {
        id: pointSeries
        axisX: axisX
        axisY: axisY
        color: root.pointColor
        borderColor: "transparent"
        markerSize: 6

        onPointAdded: index => root._rescaleArea(at(index))

        onHovered: function (point, state) {
            if (state) {
                tooltip.text = `(${point.x.toFixed(2)}, ${point.y.toFixed(2)})`;
                tooltip.visible = true;
                tooltip.x = root.mapToPosition(point, pointSeries).x + 10;
                tooltip.y = root.mapToPosition(point, pointSeries).y - 20;
            } else {
                tooltip.visible = false;
            }
        }
    }

    Tooltip {
        id: tooltip
    }

    Behavior on axisX.max {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
    Behavior on axisX.min {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
    Behavior on axisY.max {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
    Behavior on axisY.min {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    function getAll() {
        const pts = [];
        for (let i = 0; i < lineSeries.count; i++)
            pts.push(lineSeries.at(i));
        return pts;
    }

    function rescaleAxis() {
        const pts = getAll();

        let xValues = pts.map(p => p.x);
        let xMax = Math.max(...xValues);
        let xMin = Math.min(...xValues);

        let yValues = pts.map(p => p.y);
        let yMax = Math.max(...yValues);
        let yMin = Math.min(...yValues);

        console.log({
            x: xMax,
            y: yMax
        }.y);

        _rescaleArea({
            x: xMax,
            y: yMax
        });
        _rescaleArea({
            x: xMin,
            y: yMin
        });
    }

    function _rescaleArea(pt) {
        Qt.callLater(() => {
            if (!root.padding)
                return;
            const pad = root.padding;

            if (!axisX.min) {
                axisX.min = pt.x - pad;
                axisX.max = pt.x + pad;
                axisY.min = pt.y - pad;
                axisY.max = pt.y + pad;
                return;
            }

            axisX.min = Math.min(axisX.min, pt.x - pad);
            axisX.max = Math.max(axisX.max, pt.x + pad);
            axisY.min = Math.min(axisY.min, pt.y - pad);
            axisY.max = Math.max(axisY.max, pt.y + pad);
        });
    }

    WheelHandler {
        id: wheelZoom
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            const zoomFactor = event.angleDelta.y > 0 ? 0.9 : 1.1; // phóng to / thu nhỏ
            const centerX = (axisX.max + axisX.min) / 2;
            const centerY = (axisY.max + axisY.min) / 2;

            const rangeX = (axisX.max - axisX.min) * zoomFactor;
            const rangeY = (axisY.max - axisY.min) * zoomFactor;

            axisX.min = centerX - rangeX / 2;
            axisX.max = centerX + rangeX / 2;
            axisY.min = centerY - rangeY / 2;
            axisY.max = centerY + rangeY / 2;

            event.accepted = true;
        }
    }

    // MouseArea {
    //     anchors.fill: parent
    //     onClicked: mouse => {
    //         // Lấy toạ độ pixel của chuột
    //         var mousePoint = Qt.point(mouse.x, mouse.y);

    //         var plot = root.plotArea;

    //         if (!(mousePoint.x >= plot.x && mousePoint.x <= plot.x + plot.width && mousePoint.y >= plot.y && mousePoint.y <= plot.y + plot.height))
    //             return;

    //         // Chuyển sang toạ độ thực tế của trục
    //         var chartPoint = root.mapToValue(mousePoint, lineSeries);

    //         // Thêm điểm vào series
    //         lineSeries.append(chartPoint.x, chartPoint.y);

    //         console.log("Added point:", chartPoint.x, chartPoint.y);
    //     }
    // }
}
