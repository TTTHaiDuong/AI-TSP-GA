import QtQuick

Item {
    id: root
    property alias chart: chart
    property var labels: []

    BaseChart {
        id: chart
        anchors.fill: parent
        title: "Route"
        pointColor: "blue"
        pointSeries.markerSize: 10
        lineColor: "blue"
        padding: 0

        axisX.min: -0.1
        axisX.max: 1.1
        axisY.min: -0.1
        axisY.max: 1.1
    }

    function getCities() {
        const pts = [];
        for (let i = 0; i < chart.pointSeries.count; i++)
            pts.push(chart.pointSeries.at(i));
        return pts;
    }

    // function setCities(nodesList) {
    //     chart.pointSeries.clear();
    //     nodesList.forEach(n => {
    //         chart.pointSeries.append(n.x, n.y);
    //     });
    // }

    function setRoute(route) {
        chart.lineSeries.clear();
        for (let i = 0; i <= route.length; i++) {
            const point = chart.pointSeries.at(route[i % route.length]);
            chart.lineSeries.append(point.x, point.y);
        }
    }

    function setCities(nodesList) {
        chart.pointSeries.clear();

        // Xóa các label cũ
        labels.forEach(l => l.destroy());
        labels = [];

        nodesList.forEach((n, idx) => {
            chart.pointSeries.append(n.x, n.y);

            // Lấy vị trí pixel
            const pos = chart.mapToPosition({
                x: n.x,
                y: n.y
            }, chart.pointSeries);

            const label = Qt.createComponent("CityLabel.qml").createObject(root, {
                index: idx,
                x: pos.x,
                y: pos.y
            });
            labels.push(label);
        });
    }

    function updateLabels() {
        for (let i = 0; i < chart.pointSeries.count; i++) {
            const point = chart.pointSeries.at(i);
            const label = labels[i];
            label.x = point.x * chart.width - label.width / 2;
            label.y = point.y * chart.height - label.height / 2;
        }
    }

    onChartChanged: updateLabels()
}
