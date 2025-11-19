import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../LeftPanel"
import "../Bridge"
import "../Comparison"
import ".."

Rectangle {
    id: root
    property bool narrow
    property bool medium: width < 900
    property int previousTab

    property var costChartValues: [[]]

    signal inputClicked

    border.width: 1
    border.color: "#eaeaea"

    onMediumChanged: {
        if (medium && tabBar.currentIndex === 0)
            tabBar.currentIndex = previousTab;
        if (!medium && tabBar.currentIndex === 1)
            tabBar.currentIndex = 0;
    }

    Drawer {
        id: drawer
        implicitWidth: parent.width - 70
        implicitHeight: parent.height
        modal: true
        edge: Qt.LeftEdge
        topPadding: 0

        LeftPanel {
            anchors.fill: parent
            anchors.topMargin: 40
            onHeaderClicked: drawer.close()
        }
    }

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

                onClicked: drawer.open()

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
                onCurrentIndexChanged: LeftRightPanelBridge.currentTabBarIndex = currentIndex
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

                        MaterialButton {
                            anchors.top: parent.top
                            anchors.topMargin: -30
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            implicitWidth: 30
                            implicitHeight: 30
                            bgColor: "transparent"
                            radius: 8

                            Image {
                                source: "../../assets/edit.svg"
                                anchors.fill: parent
                                anchors.margins: 2
                                fillMode: Image.PreserveAspectFit
                            }

                            onClicked: {
                                if (!root.narrow)
                                    LeftRightPanelBridge.costMatrixOpenRequest();
                                else {
                                    if (!drawer.opened)
                                        LeftRightPanelBridge.costMatrixOpenRequest();
                                    drawer.open();
                                }
                            }
                        }

                        RouteMap {
                            id: routeMap
                            anchors.fill: parent
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    LineChart {
                        title: "Cost"
                        Layout.preferredWidth: !root.medium ? 480 : 0
                        Layout.preferredHeight: !root.medium ? 480 : 0
                        Layout.alignment: Qt.AlignVCenter
                        legend.visible: false

                        margins.top: 5
                        margins.bottom: 15
                        margins.left: 5
                        margins.right: 25

                        values: root.costChartValues

                        backgroundColor: "#f6f6f6ff"
                    }

                    Item {
                        Layout.fillWidth: !root.medium
                    }
                }

                RunAlgoPanel {
                    Layout.fillWidth: true

                    onRun: {
                        const cities = routeMap.getCities();
                        if (cities.length === 0)
                            return;
                        if (VariablesProps.algoIndex === 0) {
                            const result = optimizationBridge.genetic(cities, VariablesProps.gaPopSize, VariablesProps.gaGenerations, VariablesProps.gaCrossover, VariablesProps.gaMutation);
                            routeMap.setRoute(result[0]);

                            const cost = [];
                            result[1].forEach((y, i) => {
                                cost.push({
                                    x: i,
                                    y
                                });
                            });
                            root.costChartValues = [cost];
                        }
                    }
                }
            }

            // Biểu đồ chi phí
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                LineChart {
                    title: "Cost"
                    legend.visible: false

                    anchors.centerIn: parent
                    margins.top: 5
                    margins.bottom: 15
                    margins.left: 5
                    margins.right: 25

                    width: Math.max(500, parent.width - 80)
                    height: 500

                    values: root.costChartValues

                    backgroundColor: "#f6f6f6ff"
                }
            }

            // So sánh với các thuật toán + benchmark
            ComparisonTab {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Lịch sử giải bài toán
            Item {}
        }
    }

    Connections {
        target: optimizationBridge
    }

    Connections {
        target: routeBridge
    }

    Connections {
        target: CitiesInputProps

        onCitiesChanged: routeMap.setCities(CitiesInputProps.cities)
    }
}
