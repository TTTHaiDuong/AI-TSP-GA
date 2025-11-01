import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Material
import "components"

ApplicationWindow {
    id: root
    title: "TSP Solver"
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
                                    // color: "#555555ff"
                                }

                                GridLayout {
                                    id: randParamsGrid
                                    columns: 3
                                    rows: 2
                                    columnSpacing: 30
                                    rowSpacing: 0

                                    Label {
                                        id: nodeLb
                                        text: "Nodes"
                                    }

                                    Item {
                                        implicitWidth: 100
                                        implicitHeight: 16

                                        CheckBox {
                                            id: seedCheck
                                            z: 10
                                            text: "Seed"
                                            checked: true
                                            Material.accent: Theme.onFocus
                                            padding: 0
                                            verticalPadding: 0
                                        }
                                        z: 1
                                    }

                                    Item {}

                                    // --- Nodes SpinBox ---
                                    MaterialSpinBox {
                                        id: nodeCount
                                        implicitWidth: 100
                                        from: 5
                                        to: 200
                                        value: 20
                                    }

                                    // --- Seed SpinBox ---
                                    MaterialSpinBox {
                                        id: seedInput
                                        implicitWidth: 100
                                        from: 0
                                        to: 9999
                                        value: 3
                                        enabled: seedCheck.checked

                                        Rectangle {
                                            anchors.fill: parent
                                            color: "white"
                                            opacity: parent.enabled ? 0 : 0.6
                                        }
                                    }

                                    Button {
                                        id: generate
                                        implicitWidth: 100
                                        implicitHeight: 45
                                        text: "Generate"

                                        background: Rectangle {
                                            color: "#cccccc"
                                            radius: 8
                                            border.width: 1
                                            border.color: "transparent"
                                        }

                                        onClicked: {
                                            const seed = seedCheck.checked ? seedInput.value : undefined;
                                            const nodesList = routeBridge.randomize(nodeCount.value, seed);
                                            routeMap.setNodes(nodesList);
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
                                    text: "Generate the topology however you like by adjusting these parameters.\nThe app will keep a highscore for every different topology created."
                                    wrapMode: Text.WordWrap
                                    color: "#555555"
                                }

                                ColumnLayout {
                                    spacing: 0
                                    Label {
                                        text: "Algorithm"
                                    }

                                    MaterialComboxBox {
                                        id: algoBox
                                        model: ["Genetic", "PSO"]
                                    }
                                }

                                // Chế độ nhập tham số GA
                                Item {
                                    visible: algoBox.currentText === "Genetic"
                                    Layout.fillWidth: true
                                    implicitHeight: genFlow.implicitHeight

                                    Flow {
                                        id: genFlow
                                        width: varMenu.width
                                        spacing: 30
                                        Repeater {
                                            model: ["Population size", "Generations", "Crossover rate", "Mutation rate"]
                                            delegate: ColumnLayout {
                                                width: 140
                                                spacing: 0
                                                Label {
                                                    text: modelData
                                                }
                                                MaterialSpinBox {
                                                    from: 0
                                                    to: 9999
                                                    value: 3
                                                }
                                            }
                                        }
                                    }
                                }

                                // Chế độ nhập các tham số PSO
                                Item {
                                    visible: algoBox.currentText === "PSO"
                                    Layout.fillWidth: true
                                    implicitHeight: psoFlow.implicitHeight

                                    Flow {
                                        id: psoFlow
                                        width: varMenu.width
                                        spacing: 30
                                        Repeater {
                                            model: ["Swarm size", "Initial Velocity", "Inertia Weight", "Cognitive Coefficient", "Social Coefficient", "Velocity Clamping", "Number of Iterations"]
                                            delegate: ColumnLayout {
                                                width: 140
                                                spacing: 0
                                                Label {
                                                    text: modelData
                                                }
                                                MaterialSpinBox {
                                                    from: 0
                                                    to: 9999
                                                    value: 3
                                                }
                                            }
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
                        width: implicitWidth
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        padding: 0
                        anchors.margins: 0
                        Material.accent: Theme.onFocus

                        TabButton {
                            text: "Route and fitness"
                            width: 150
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                        }
                        TabButton {
                            text: "History"
                            width: 100
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                        }
                        TabButton {
                            text: "Benchmark"
                            width: 100
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                        }
                    }
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    currentIndex: chartsBar.currentIndex

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RouteMap {
                            id: routeMap
                            anchors.left: parent.left
                            width: parent.width / 2
                            height: width * 1.2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Chart {
                            id: fitnessChart
                            title: "Fitness"
                            anchors.right: parent.right
                            width: parent.width / 2
                            height: width * 1.2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }

    // --- Kết nối QML với Python ---
    Connections {
        target: fitnessBridge

        function onPointAdded(pt) {
            fitnessChart.addPoint(pt.x, pt.y);
        }
    }

    Connections {
        target: routeBridge

        function onRandomized(nodesList) {
            routeMap.setNodes(nodesList);
        }
    }
}
