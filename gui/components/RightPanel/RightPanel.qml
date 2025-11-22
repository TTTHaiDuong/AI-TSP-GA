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

    signal inputClicked

    border.width: 1
    border.color: "#eaeaea"

    onMediumChanged: {
        if (medium && tabBar.currentIndex === 0)
            tabBar.currentIndex = previousTab;
        if (!medium && tabBar.currentIndex === 1)
            tabBar.currentIndex = 0;
    }

    function openRouteMapEdit() {
        if (!root.narrow)
            LeftRightPanelBridge.costMatrixOpenRequest();
        else {
            if (!drawer.opened)
                LeftRightPanelBridge.costMatrixOpenRequest();
            drawer.open();
        }
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
                    model: ["Comparison"]
                    delegate: TabButton {
                        text: modelData
                        width: 100
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }

        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical: ScrollBar {
                id: cscrollBar
                width: 12
                policy: stackLayout.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }

            StackLayout {
                id: stackLayout
                width: scrollView.width
                height: scrollView.height
                currentIndex: tabBar.currentIndex

                // Bản đồ và biểu đồ chi phí
                RouteAndCostTab {
                    id: routeNCostTab
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    onEditClicked: root.openRouteMapEdit()
                }

                // Biểu đồ chi phí
                Item {
                    Layout.fillWidth: true

                    LineChart {
                        anchors.centerIn: parent
                        margins.top: 5
                        margins.bottom: 15
                        margins.left: 5
                        margins.right: 25

                        width: Math.max(500, parent.width - 80)
                        height: 500

                        values: routeNCostTab.costChartValues

                        backgroundColor: "#f6f6f6ff"
                    }
                }

                // So sánh với các thuật toán
                ComparisonTab {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    onEditClicked: root.openRouteMapEdit()
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
}
