import QtQuick

Item {
    id: root
    property alias chart: chart

    Chart {
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

    function getNodes() {
        const pts = [];
        for (let i = 0; i < chart.points.count; i++)
            pts.push(chart.points.at(i));
        return pts;
    }

    function setNodes(nodesList) {
        chart.points.clear();
        nodesList.forEach(n => {
            chart.points.append(n.x, n.y);
        });
    }
}
