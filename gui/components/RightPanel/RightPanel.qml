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

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: header
            Layout.fillWidth: true
            implicitHeight: 40

            Rectangle {
                id: inputButton
                color: "#eaeaea"

                Label {
                    text: "Input"
                    anchors.centerIn: parent
                    visible: root.narrow
                }
                width: root.narrow ? 100 : 0
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                clip: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.inputClicked();
                    }
                    hoverEnabled: true
                    onEntered: parent.color = "#aeaeae"  // màu khi hover
                    onExited: parent.color = "#eaeaea"
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            TabBar {
                id: tabBar

                anchors {
                    left: inputButton.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                padding: 0
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
                    model: ["Benchmark", "Comparison", "History"]
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

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    Layout.alignment: Qt.AlignHCenter

                    Item {
                        Layout.fillWidth: true
                    }

                    RouteMap {
                        id: routeMap
                        Layout.preferredWidth: 500
                        Layout.preferredHeight: 500
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    CostPlot {
                        title: "Cost"
                        Layout.preferredWidth: !root.medium ? 500 : 0
                        Layout.preferredHeight: !root.medium ? 500 : 0
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: !root.medium
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                CostPlot {
                    id: costPlot
                    title: "Cost"
                    width: Math.max(500, parent.width - 80)
                    height: 500
                    anchors.centerIn: parent
                }
            }

            Item {}

            Item {}
        }

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
                            anchors.centerIn: parent
                            text: "Optimize"
                            color: "white"
                            font.bold: true
                        }

                        onClicked: {
                            const cities = routeMap.getCities();
                            if (cities.length === 0)
                                return;
                            if (VariablesProps.algoIndex === 0) {
                                const result = optimizationBridge.genetic(cities, VariablesProps.gaPopSize, VariablesProps.gaGenerations, VariablesProps.gaCrossover, VariablesProps.gaMutation);
                                routeMap.setRoute(result[0]);
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
                            implicitHeight: 0
                            color: "#ffffffff"
                            radius: 8
                            anchors.bottom: parent.top
                            Label {
                                text: "Epoch " + Math.round(slider.value) + "/" + slider.to
                                anchors.centerIn: parent
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
        target: RandTopologyProps

        function onGenerateClick(params) {
            console.log("AÂ");
            const result = routeBridge.randomize(RandTopologyProps.citiesNum, RandTopologyProps.seed);
            routeMap.setCities(result);
        }
    }
}
