import QtCharts
import QtQuick
import ".."

ChartView {
    id: root
    antialiasing: true
    backgroundColor: "#f6f6f6ff"

    property real padding: 1.0
    property var labels: ["Genetic", "PSO", "ACO", "SA", "Held-Karp"]
    property var values: [[], [], [], [], []]

    onValuesChanged: {
        clear();
        axisx.min = 0;
        axisx.max = padding;
        axisy.min = 0;
        axisy.max = padding;

        for (let i = 0; i < values.length; i++) {
            var series = root.createSeries(ChartView.SeriesTypeLine, labels[i]);
            series.axisX = axisx;
            series.axisY = axisy;

            values[i].forEach(v => {
                series.append(v.x, v.y);
            });
            lines.push(series);
        }

        rescaleAxis();
    }

    readonly property var lines: []

    function clear() {
        lines.forEach(l => {
            root.removeSeries(l);
            l.destroy();
        });
        lines.length = 0;
    }

    // MouseArea {
    //     anchors.fill: parent
    //     onClicked: {
    //         root.clear();
    //     }
    // }

    ValueAxis {
        id: axisx

        Behavior on max {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        Behavior on min {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    ValueAxis {
        id: axisy

        Behavior on max {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        Behavior on min {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    function rescaleAxis() {
        Qt.callLater(() => {
            const pts = Utils.flattenDeep(values);
            if (pts.length === 0)
                return;

            let xValues = pts.map(p => p.x);
            let yValues = pts.map(p => p.y);

            axisx.min = Math.min(...xValues) - root.padding;
            axisx.max = Math.max(...xValues) + root.padding;
            axisy.min = Math.min(...yValues) - root.padding;
            axisy.max = Math.max(...yValues) + root.padding;
        });
    }
}
