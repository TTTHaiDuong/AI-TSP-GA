import QtQuick

Item {
    id: root
    property alias chart: chart
    property alias direction: directedContainer
    property var labels: []

    BaseChart {
        id: chart
        anchors.fill: parent
        title: "Route"
        pointColor: "blue"
        pointSeries.markerSize: 10
        lineColor: "blue"
        padding: 0

        axisX.min: -1
        axisX.max: 11
        axisY.min: -1
        axisY.max: 11
    }

    Item {
        id: directedContainer
        anchors.fill: parent

        Component {
            id: arrow
            Arrow {
                anchors.fill: parent
            }
        }

        readonly property var route: []
        readonly property var children: []

        function show() {
            off();
            for (let i = 0; i < route.length; i++) {
                const arrowComp = arrow.createObject(directedContainer, {
                    startPoint: route[i],
                    endPoint: route[(i + 1) % route.length]
                });
                children.push(arrowComp);
            }
        }

        function off() {
            children.forEach(c => c.destroy());
            children.length = 0;
        }
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
        directedContainer.route.length = 0;

        for (let i = 0; i <= route.length; i++) {
            const point = chart.pointSeries.at(route[i % route.length]);
            chart.lineSeries.append(point.x, point.y);

            const mappedPt = chart.mapToPosition(Qt.point(point.x, point.y), chart.lineSeries);
            directedContainer.route.push({
                x: mappedPt.x,
                y: mappedPt.y
            });
        }
    }

    function setCities(nodesList) {
        chart.pointSeries.clear();

        clearLabel();

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

    function clearLabel() {
        labels.forEach(l => l.destroy());
        labels = [];
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
