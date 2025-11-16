import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "./../RightPanel"
import ".."

Item {
    id: root
    property bool openCostMatrix

    LeftPanel {
        visible: !root.openCostMatrix
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.fill: parent
        // anchors.bottomMargin: 80
        spacing: 0

        // Dãy tiêu đề trên cùng
        MaterialButton {
            Layout.fillWidth: true
            implicitHeight: 40
            pressScale: false

            Label {
                text: "Cost matrix"
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: 40

            TabBar {
                id: tabBar
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Material.accent: Theme.onFocus

                Repeater {
                    model: ["Cities", "Matrix", "Rules"]
                    delegate: TabButton {
                        text: modelData
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 100
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            Item {}

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Item {
                    anchors {
                        fill: parent
                        topMargin: 40
                        leftMargin: 20
                        rightMargin: 10
                        bottomMargin: 10
                    }

                    MatrixTable {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        width: Math.min(parent.width, implicitWidth)
                        height: Math.min(parent.height, implicitHeight)
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 40
        }
    }
}
