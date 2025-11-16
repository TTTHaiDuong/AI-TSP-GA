import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Drawer {
    id: root
    implicitWidth: parent.width - 70
    implicitHeight: parent.height
    modal: true
    edge: Qt.RightEdge
    topPadding: 0
    visible: true

    property int cellWidth: 60
    property int cellHeight: 40
    property var costMatrix: [[0, 10, 15,
            {
                dist: 15,
                weight: 5
            },
            25], [10, 0, 35, 25, 30], [15, 35, 0, 30, 20], [20, 25, 30, 0, 15], [25, 30, 20, 15, 0]]
    onCostMatrixChanged: matrixGrid.update()

    // function isClipped(cell) {
    //     if (!cell)
    //         return false;

    //     // Góc trái trên của cell trong hệ tọa độ contentItem
    //     var topLeft = cell.mapToItem(scrollView.contentItem, 0, 0);
    //     // Góc phải dưới
    //     var bottomRight = cell.mapToItem(scrollView.contentItem, cell.width, cell.height);

    //     return !(bottomRight.x < 0 || topLeft.x > scrollView.width || bottomRight.y < 0 || topLeft.y > scrollView.height);
    // }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 40
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

            onClicked: root.close()
        }

        MatrixTable {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 160
            color: Theme.unFocus
        }
    }
}
