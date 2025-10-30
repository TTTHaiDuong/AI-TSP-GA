import QtCharts
import QtQuick.Controls
import QtQuick

ChartView {
    id: root
    antialiasing: true
    legend.visible: false
    margins.top: 1
    margins.bottom: 1
    margins.left: 1
    margins.right: 1

    property double padding: 1.0
    property color pointColor: "red"
    property color lineColor: "red"
    property alias axisX: axisX
    property alias axisY: axisY
    property alias lines: lineSeries
    property alias points: pointSeries

    ValueAxis {
        id: axisX
        min: 0
        max: 1
    }

    ValueAxis {
        id: axisY
        min: 0
        max: 1
    }

    LineSeries {
        id: lineSeries
        axisX: axisX
        axisY: axisY
        color: root.lineColor
        width: 2

        onPointAdded: index => {
            Qt.callLater(() => {
                const pt = at(index);

                if (pt.x < axisX.min + root.padding)
                    axisX.min = pt.x - root.padding;
                if (pt.x > axisX.max - root.padding)
                    axisX.max = pt.x + root.padding;
                if (pt.y < axisY.min + root.padding)
                    axisY.min = pt.y - root.padding;
                if (pt.y > axisY.max - root.padding)
                    axisY.max = pt.y + root.padding;
            });
        }
    }

    ScatterSeries {
        id: pointSeries
        axisX: axisX
        axisY: axisY
        color: root.pointColor
        borderColor: "transparent"
        markerSize: 6

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

    // WheelHandler {
    //     id: wheelZoom
    //     acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    //     onWheel: event => {
    //         const zoomFactor = event.angleDelta.y > 0 ? 0.9 : 1.1; // phóng to / thu nhỏ
    //         const centerX = (axisX.max + axisX.min) / 2;
    //         const centerY = (axisY.max + axisY.min) / 2;

    //         const rangeX = (axisX.max - axisX.min) * zoomFactor;
    //         const rangeY = (axisY.max - axisY.min) * zoomFactor;

    //         axisX.min = centerX - rangeX / 2;
    //         axisX.max = centerX + rangeX / 2;
    //         axisY.min = centerY - rangeY / 2;
    //         axisY.max = centerY + rangeY / 2;

    //         event.accepted = true;
    //     }
    // }

    Button {
        text: "Thêm ngẫu nhiên"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            let x = lineSeries.count;
            let y = Math.random() * 10;

            lineSeries.append(x, y);
            pointSeries.append(x, y);
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
    // Hàm để xóa dữ liệu cũ
    function clear() {
        lineSeries.clear();
        pointSeries.clear();
        // Reset trục tọa độ về giá trị ban đầu
        axisX.min = 0;
        axisX.max = 1;
        axisY.min = 0;
        axisY.max = 1;
    }

    // Hàm để thêm một điểm mới (cho dễ gọi từ bên ngoài)
    function addPoint(x, y) {
        lineSeries.append(x, y);
        pointSeries.append(x, y);
    }
}
