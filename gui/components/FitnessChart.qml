import QtQuick 2.15
import QtCharts 2.15

ChartView {
    id: chart
    title: "Biểu đồ kết quả"
    antialiasing: true
    legend.visible: true

    LineSeries {
        name: "Fitness"
        color: "steelblue"

        XYPoint { x: 0; y: 10 }
        XYPoint { x: 1; y: 8 }
        XYPoint { x: 2; y: 6 }
        XYPoint { x: 3; y: 4 }
        XYPoint { x: 4; y: 3 }
    }
}