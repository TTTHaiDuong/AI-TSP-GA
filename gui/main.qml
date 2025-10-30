import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Material
import "components"

ApplicationWindow {
    id: root
    visible: true
    title: "TSP Solver using Genetic Algorithm"
    width: 1200
    height: 800
    color: Theme.background

    // Container dãy công cụ trên cùng (nút save,...) + nội dung gồm hai control panel trái và phải
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Dãy công cụ phía trên cùng
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "white"
            border.width: 1
            border.color: "#e0e0e0ff"
        }

        // Container hai control panel trái và phải
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Control panel bên trái: điều chỉnh các tham số
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0.4
                spacing: 0

                // Dãy có chữ Input
                Rectangle {
                    id: inputHeader
                    Layout.fillWidth: true
                    implicitHeight: 40
                    color: "#eaeaea"

                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Input"
                    }
                }

                // Scroll view cho danh sách menu drop (Random Topology, Variables)
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    ScrollBar.vertical: ScrollBar {
                        width: 12
                        policy: dropMenuList.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }

                    // Danh sách các menu drop
                    Column {
                        id: dropMenuList
                        width: parent.parent.width

                        // Random Topology
                        MaterialDropContent {
                            title: "Random Topology"

                            ColumnLayout {
                                id: topoContent
                                spacing: 30

                                Label {
                                    text: "Khởi tạo các điểm.\nNhấn vào nút \"Generate\" để sử dụng chức năng sinh ngẫu nhiên\nhoặc thao tác trực tiếp trên Route Map."
                                    wrapMode: Text.WordWrap
                                }

                                GridLayout {
                                    columns: 3
                                    rows: 2
                                    columnSpacing: 30
                                    rowSpacing: 0

                                    Label { text: "Nodes" }
                                    Label { text: "Seed" }
                                    Item {}

                                    MaterialSpinBox {
                                        id: nodeCount
                                        implicitWidth: 100
                                        from: 5
                                        to: 200
                                        value: 20
                                    }

                                    MaterialSpinBox {
                                        id: seedInput
                                        implicitWidth: 100
                                        from: 0
                                        to: 9999
                                        value: 3
                                    }

                                    Button {
                                        id: generate
                                        implicitWidth: 100
                                        implicitHeight: 45
                                        text: "Generate"

                                        background: Rectangle {
                                            color: "#cccccc"
                                            radius: 8
                                        }

                                        // SỬA LỖI: onClicked được đặt đúng bên trong Button
                                        onClicked: {
                                            // Gọi hàm trong Python controller
                                            appController.generate_cities(nodeCount.value, seedInput.value)
                                        }
                                    }
                                }
                            }
                        }

                        // Menu drop Variables
                        MaterialDropContent {
                            id: varMenu
                            title: "Variables"
                            Layout.fillWidth: true

                            ColumnLayout {
                                spacing: 30

                                Label {
                                    text: "Điều chỉnh các tham số của thuật toán."
                                    wrapMode: Text.WordWrap
                                    color: "#555555ff"
                                }

                                ColumnLayout {
                                    spacing: 0
                                    Label { text: "Algorithm" }
                                    MaterialComboxBox {
                                        id: algoBox
                                        model: ["Genetic", "PSO"]
                                    }
                                }

                                // Chế độ nhập tham số GA
                                // SỬA LỖI: Bỏ Repeater, dùng ID trực tiếp cho an toàn
                                Item {
                                    visible: algoBox.currentText === "Genetic"
                                    Layout.fillWidth: true
                                    implicitHeight: genFlow.implicitHeight

                                    Flow {
                                        id: genFlow
                                        width: varMenu.width
                                        spacing: 30

                                        ColumnLayout {
                                            width: 140; spacing: 0
                                            Label { text: "Population size" }
                                            MaterialSpinBox { id: popSizeInput; from: 10; to: 9999; value: 100 }
                                        }
                                        ColumnLayout {
                                            width: 140; spacing: 0
                                            Label { text: "Generations" }
                                            MaterialSpinBox { id: generationsInput; from: 10; to: 9999; value: 500 }
                                        }
                                        ColumnLayout {
                                            width: 140; spacing: 0
                                            Label { text: "Crossover rate (%)" } // Thêm (%) vào nhãn
                                            MaterialSpinBox { id: crossoverInput; from: 0; to: 100; value: 90 } // Dùng giá trị nguyên: 0-100
                                        }
                                        ColumnLayout {
                                            width: 140; spacing: 0
                                            Label { text: "Mutation rate (%)" } // Thêm (%) vào nhãn
                                            MaterialSpinBox { id: mutationInput; from: 0; to: 100; value: 1 } // Dùng giá trị nguyên: 0-100
                                        }
                                    }
                                }

                                // Chế độ nhập các tham số PSO (chưa sử dụng)
                                Item {
                                    visible: algoBox.currentText === "PSO"
                                    Layout.fillWidth: true
                                    // ...
                                }

                                // Nút để chạy thuật toán
                                Button {
                                    id: runButton
                                    text: "Run Algorithm"
                                    Layout.topMargin: 20
                                    Layout.alignment: Qt.AlignHCenter
                                    implicitWidth: 200
                                    implicitHeight: 45
                                    background: Rectangle { color: "#4CAF50"; radius: 8 }

                                    onClicked: {
                                        if (algoBox.currentText === "Genetic") {
                                            var gaParams = {
                                                "populationSize": popSizeInput.value,
                                                "generations": generationsInput.value,
                                                // Chia cho 100.0 để chuyển thành số thập phân
                                                "crossoverRate": crossoverInput.value / 100.0, // Gửi đi 0.9
                                                "mutationRate": mutationInput.value / 100.0   // Gửi đi 0.01
                                            }
                                            appController.run_ga(gaParams)
                                        } else {
                                            console.log("PSO not implemented yet.")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Control Panel bên phải: biểu đồ Route + Fitness
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0.6

                Rectangle {
                    Layout.fillWidth: true
                    color: "#eaeaea"
                    implicitHeight: 40

                    TabBar {
                        id: chartsBar
                        // ...
                        TabButton { text: "Route and fitness" }
                        TabButton { text: "History" }
                        TabButton { text: "Benchmark" }
                    }
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: chartsBar.currentIndex

                    Item {
                        RouteMap {
                            id: routeChart
                            title: "Route"
                            anchors.left: parent.left
                            width: parent.width / 2
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Chart {
                            id: fitnessChart
                            title: "Fitness"
                            anchors.right: parent.right
                            width: parent.width / 2
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }

    // --- Kết nối QML với Python Controller ---
    Connections {
        target: appController // Đổi tên thành appController

        function onUpdateFitnessChart(pt) {
            fitnessChart.addPoint(pt.x, pt.y);
        }

        function onDrawNodesOnMap(nodes) {
            routeChart.drawNodes(nodes);
        }

        function onDrawRouteOnMap(route) {
            routeChart.drawRoute(route);
        }

        function onClearCharts() {
            fitnessChart.clear();
            routeChart.clear();
        }
    }
}