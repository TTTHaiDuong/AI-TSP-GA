import QtQuick

Item {
    id: root
    property alias chart: chart

    CostPlot {
        id: chart
        anchors.fill: parent
        title: "Route"
        pointColor: "blue"
        lineColor: "blue"
        padding: 0
        axisX.min: -0.1
        axisX.max: 1.1
        axisY.min: -0.1
        axisY.max: 1.1
    }

    function getCities() {
        const pts = [];
        for (let i = 0; i < chart.points.count; i++)
            pts.push(chart.points.at(i));
        return pts;
    }

    function setCities(nodesList) {
        chart.points.clear();
        nodesList.forEach(n => {
            chart.points.append(n.x, n.y);
        });
    }

    function setRoute(route) {
        for (let i = 0; i <= route.length; i++) {
            const point = chart.points.at(route[i % route.length]);
            chart.lines.append(point);
        }
    }
}
