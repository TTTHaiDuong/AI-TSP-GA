import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import "components"
import "components/LeftPanel"
import "components/RightPanel"

ApplicationWindow {
    id: root
    title: "TSP Solver"
    color: Theme.background
    minimumWidth: 500
    minimumHeight: 400
    width: Screen.width
    height: Screen.height
    visible: Window.Maximized

    property bool narrow: width <= 900
    property bool drawerState

    Item {
        anchors.fill: parent

        // Container dãy công cụ trên cùng (nút save,...) + nội dung gồm hai control panel trái và phải
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Dãy công cụ phía trên cùng
            Rectangle {
                id: topTools
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "white"
                border.width: 1
                border.color: "#e0e0e0ff"
            }

            // Container hai control panel trái và phải
            SplitView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Control panel bên trái: điều chỉnh các tham số
                LeftPanel {
                    openCostMatrix: true
                    visible: !root.narrow
                    SplitView.preferredWidth: 500
                    SplitView.minimumWidth: 300
                    height: parent.height
                }

                // Control Panel bên phải
                RightPanel {
                    narrow: root.narrow
                    SplitView.fillWidth: true
                    SplitView.minimumWidth: 500

                    // onInputClicked: drawer.open()
                }
            }
        }
    }

    // --- Kết nối QML với Python ---
    // Connections {
    //     target: fitnessBridge

    //     function onPointAdded(pt) {
    //         fitnessChart.addPoint(pt.x, pt.y);
    //     }
    // }

    // Connections {
    //     target: routeBridge

    //     function onRandomized(nodesList) {
    //         routeMap.setNodes(nodesList);
    //     }
    // }
}
