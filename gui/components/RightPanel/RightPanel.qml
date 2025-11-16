import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

Rectangle {
    id: root
    property bool narrow
    property bool medium: width < 900
    property int previousTab

    signal inputClicked

    border.width: 1
    border.color: "#eaeaea"

    onMediumChanged: {
        if (medium && tabBar.currentIndex === 0)
            tabBar.currentIndex = previousTab;
        if (!medium && tabBar.currentIndex === 1)
            tabBar.currentIndex = 0;
    }

    AsymmetricRulesPanel {
        visible: false
    }

    CostMatrixPanel {}

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: header
            Layout.fillWidth: true
            implicitHeight: 40

            // Nút "Input" để mở bản điều khiển bên trái khi màn hình hẹp
            MaterialButton {
                id: inputBtn
                width: root.narrow ? 100 : 0
                bgColor: "#eaeaea"
                pressScale: false
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

                onClicked: root.inputClicked()

                Label {
                    text: "Input"
                    anchors.centerIn: parent
                    visible: root.narrow
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            // Thanh các menu tab
            TabBar {
                id: tabBar

                anchors {
                    left: inputBtn.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                Material.accent: Theme.onFocus

                TabButton {
                    text: !root.medium ? "Route and cost" : "Route"
                    width: !root.medium ? 150 : 100
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    onClicked: root.previousTab = 0
                }
                TabButton {
                    text: "Cost"
                    width: root.medium ? 100 : 0
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    onClicked: root.previousTab = 1
                }
                Repeater {
                    model: ["Comparison", "History"]
                    delegate: TabButton {
                        text: modelData
                        width: 100
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: tabBar.currentIndex

            // Bản đồ và biểu đồ chi phí
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 40

                    Text {
                        text: "Genetic's Optimization"
                        anchors.centerIn: parent
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.preferredWidth: 480
                        Layout.preferredHeight: 480

                        RouteMap {
                            id: routeMap
                            anchors.fill: parent
                            Layout.alignment: Qt.AlignVCenter
                        }
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
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    BaseChart {
                        id: costChart
                        title: "Cost"
                        Layout.preferredWidth: !root.medium ? 480 : 0
                        Layout.preferredHeight: !root.medium ? 480 : 0
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: !root.medium
                    }
                }
            }

            // Biểu đồ chi phí
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                BaseChart {
                    title: "Cost"
                    width: Math.max(480, parent.width - 80)
                    height: 480
                    anchors.centerIn: parent
                }
            }

            // So sánh với các thuật toán + benchmark
            Item {}

            // Lịch sử giải bài toán
            Item {}
        }

        // Nút solve + thanh slider
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 160
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 50

                RowLayout {
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 30

                    MaterialButton {
                        id: runBtn
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 100
                        implicitHeight: 40
                        radius: 8
                        bgColor: "#6e6e6e"
                        Label {
                            text: "Solve"
                            color: "white"
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        onClicked: {
                            const cities = routeMap.getCities();
                            if (cities.length === 0)
                                return;
                            if (VariablesProps.algoIndex === 0) {
                                const result = optimizationBridge.genetic(cities, VariablesProps.gaPopSize, VariablesProps.gaGenerations, VariablesProps.gaCrossover, VariablesProps.gaMutation);
                                routeMap.setRoute(result[0]);
                                costChart.lines.clear();
                                result[1].forEach(y => {
                                    const x = costChart.lines.count;
                                    costChart.lines.append(x, y);
                                });
                            }
                        }
                    }

                    Slider {
                        id: slider
                        from: 1
                        to: 1000
                        value: 50
                        Layout.fillWidth: true
                        Material.accent: Theme.onFocus

                        Rectangle {
                            implicitWidth: 100
                            color: "#ffffffff"
                            radius: 8
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 5
                            Label {
                                text: "Epoch " + Math.round(slider.value) + "/" + slider.to + " (Early Stopping)"
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }
                        }

                        onValueChanged:
                        // console.log("Giá trị Slider:", value);
                        {}

                        // MouseArea {
                        //     id: hoverArea
                        //     anchors.fill: parent
                        //     hoverEnabled: true
                        //     onPositionChanged: {
                        //         // Tính toán giá trị tương ứng theo vị trí chuột
                        //         let rel = Math.max(0, Math.min(1, mouse.x / width));
                        //         slider.value = slider.from + rel * (slider.to - slider.from);
                        //     }
                        // }

                        Tooltip {
                            id: sliderTooltip
                            visible: slider.pressed
                            y: slider.handle.y - height - 6
                            x: slider.handle.x + slider.handle.width / 2 - width / 2
                            text: Math.round(slider.value)
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: optimizationBridge
    }

    Connections {
        target: routeBridge
    }

    Connections {
        target: RandTopologyProps

        function onGenerateBtnClicked(params) {
            const result = routeBridge.randomize(RandTopologyProps.citiesNum, RandTopologyProps.seed);
            routeMap.setCities(result);
        }
    }
}
