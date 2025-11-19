import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

ColumnLayout {
    id: root
    spacing: 0

    signal headerClicked

    onVisibleChanged: update()

    function update() {
        citiesInput.updateFromBridge();
        rulesInput.updateFromBridge();
    }

    Component.onCompleted: {
        if ("opened" in parent) {
            parent.onOpenedChanged.connect(update);
        }
    }

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

        onClicked: {
            if (!("opened" in root.parent.parent))
                LeftRightPanelBridge.costMatrixOpenRequest();
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

            onCurrentIndexChanged: {
                if (currentIndex === 0)
                    citiesInput.updateFromBridge();
                if (currentIndex === 1) {
                    matrixTable.costMatrix = costMatrixBridge.generate_from(CitiesInputProps.cities || [], AsymmetricRulesInputProps.rules || []);
                }
                if (currentIndex === 2)
                    rulesInput.updateFromBridge();
            }

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

        // Nhập toạ độ các thành phố
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            CitiesInput {
                id: citiesInput
                anchors {
                    fill: parent
                    bottomMargin: 80
                    leftMargin: 10
                    rightMargin: 10
                }
            }
        }

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
                    id: matrixTable
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    width: Math.min(parent.width, implicitWidth)
                    height: Math.min(parent.height, implicitHeight)
                }
            }
        }

        // Nhập luật bất đối xứng
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            AsymmetricRulesInput {
                id: rulesInput
                anchors {
                    fill: parent
                    bottomMargin: 80
                    leftMargin: 10
                    rightMargin: 10
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
    }

    Connections {
        target: costMatrixBridge
    }
}
