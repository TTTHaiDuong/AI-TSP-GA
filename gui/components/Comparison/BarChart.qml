import QtQuick
import QtCharts
import ".."

ChartView {
    id: root
    antialiasing: true

    property var values: [[1, 2, 125, 4, 5], [1, 2, 3, 4, 5]]
    property var features
    property var normalizedValues
    property real barWidth: 0.8

    onValuesChanged: {
        algoSeries.clear();
        overlay.clear();

        const globalMax = Utils.findMaxND(values);

        // Đặt chiều cao trục Y bằng 1.2 lần giá trị lớn nhất để cột không bị quá ngắn
        axisY.max = 1.2 * globalMax.maxVal;

        // So đều tỉ lệ chiều cao các cột giữa các feature
        const normalizedValues = [];
        for (let i = 0; i < values.length; i++) {
            let normalize = values[i];
            if (i !== globalMax.maxPos[0]) {
                const max = Math.max(...values[i]);
                normalize = values[i].map(x => x * globalMax.maxVal / max);
            }
            normalizedValues.push(normalize);
        }
        root.normalizedValues = normalizedValues;

        for (let i = 0; i < values.length; i++) {
            algoSeries.append(features ? features[i] : "", normalizedValues[i]);
            values[i].forEach((_, j) => overlay.add(i, j));
        }
    }

    BarCategoryAxis {
        id: axisX
        categories: ["Genetic", "PSO", "ACO", "SA", "Held-Karp"]
    }

    ValueAxis {
        id: axisY
        min: 0
        max: 20
        visible: false
    }

    BarSeries {
        id: algoSeries
        axisX: axisX
        axisY: axisY
        barWidth: root.barWidth
    }

    Item {
        id: overlay
        anchors.fill: parent

        Component {
            id: barTopComponent
            Text {
                property int labelIndex: 0
                property int algoIndex: 0

                function barCenterX() {
                    const cols = root.values[labelIndex].length;
                    const w = root.plotArea.width / cols;
                    const base = (1 - root.barWidth) / 2;
                    const offset = (labelIndex + 0.5) * (root.barWidth / root.values.length);
                    return root.plotArea.x + (algoIndex + base + offset) * w;
                }

                function barTopY() {
                    const ratio = root.normalizedValues[labelIndex][algoIndex] / axisY.max;
                    return root.plotArea.y + root.plotArea.height * (1 - ratio);
                }

                function barWidth() {
                    return root.plotArea.width / root.values.length / 2 / root.values[labelIndex].length;
                }

                text: root.values[labelIndex][algoIndex]
                elide: Qt.ElideRight
                width: barWidth()
                x: barCenterX() - implicitWidth / 2
                y: barTopY() - implicitHeight
            }
        }

        property var children: []

        function add(lbIdx, algoIdx) {
            const val = barTopComponent.createObject(overlay, {
                labelIndex: lbIdx,
                algoIndex: algoIdx
            });
            children.push(val);
        }

        function clear() {
            children.forEach(c => c.destroy());
            children = [];
        }

        // Test
        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         const arr = root.values.slice();
        //         arr[0][2] += 10;
        //         root.values = arr;
        //     }
        // }
    }
}
