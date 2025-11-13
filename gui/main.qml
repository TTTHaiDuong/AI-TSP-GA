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
    width: 1200
    height: 800
    color: Theme.background
    minimumWidth: 500
    minimumHeight: 400

    property bool narrow: width <= 900
    property bool medium: !narrow && width < 1200
    property bool drawerState

    Item {
        anchors.fill: parent

        Drawer {
            id: drawer
            implicitWidth: parent.width - 70
            implicitHeight: parent.height
            modal: true
            edge: Qt.LeftEdge
            topPadding: 0
            visible: root.narrow && root.drawerState

            LeftPanel {
                anchors.fill: parent
                anchors.topMargin: 40
                onInputClicked: drawer.close()
            }
        }

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
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Control panel bên trái: điều chỉnh các tham số
                LeftPanel {
                    visible: !root.narrow
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.3
                }

                // Control Panel bên phải: biểu đồ Route + Fitness
                RightPanel {
                    narrow: root.narrow
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.7

                    onInputClicked: drawer.open()
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
