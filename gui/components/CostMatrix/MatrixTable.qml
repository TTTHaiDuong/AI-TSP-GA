import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

Item {
    id: root
    implicitWidth: cellWidth + matrixGrid.implicitWidth + vScrollBar.width + 2 * matrixGrid.columnSpacing
    implicitHeight: cellHeight + matrixGrid.implicitHeight + hScrollBar.height + 2 * matrixGrid.rowSpacing

    property int cellWidth: 60
    property int cellHeight: 40
    property var costMatrix: [[0, 10, 15,
            {
                dist: 15,
                weight: 5
            },
            25], [10, 0, 35, 25, 30], [15, 35, 0, 30, 20], [20, 25, 30, 0, 15], [25, 30, 20, 15, 0]]

    onCostMatrixChanged: {
        if (costMatrix && costMatrix.length >= 2)
            matrixGrid.update();
    }

    // Dãy tiêu đề trên
    Item {
        id: matrixCHeader
        clip: true
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: root.cellWidth + matrixGrid.columnSpacing
            right: parent.right
            rightMargin: -vScrollBar.anchors.rightMargin
        }
        height: root.cellHeight

        RowLayout {
            x: -scrollView.contentItem.contentX
            Repeater {
                model: root.costMatrix.length
                Rectangle {
                    id: cell
                    width: root.cellWidth
                    height: root.cellHeight
                    color: matrixGrid.selectedCell && matrixGrid.selectedCell.col === col ? Theme.onFocus : Theme.unFocus
                    radius: 3

                    property int row: -1
                    property int col: index

                    Text {
                        anchors.centerIn: parent
                        text: "E" + (index + 1)
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.costMatrix[index] !== undefined && parent.col < root.costMatrix[index].length) {
                                const current = matrixGrid.selectedCell;
                                matrixGrid.highlight((current && (mouse.modifiers & Qt.ControlModifier)) ? current.row : parent.row, parent.col);
                            }
                        }
                    }
                }
            }
        }
    }

    // Dãy tiêu đề bên trái
    Item {
        id: matrixRHeader
        clip: true
        anchors {
            top: parent.top
            topMargin: root.cellHeight + matrixGrid.rowSpacing
            left: parent.left
            bottom: parent.bottom
            bottomMargin: -hScrollBar.anchors.bottomMargin
        }
        width: root.cellWidth

        ColumnLayout {
            y: -scrollView.contentItem.contentY
            Repeater {
                model: root.costMatrix.length
                Rectangle {
                    width: root.cellWidth
                    height: root.cellHeight
                    color: matrixGrid.selectedCell && matrixGrid.selectedCell.row === row ? Theme.onFocus : Theme.unFocus
                    radius: 3

                    property int row: index
                    property int col: -1

                    Text {
                        anchors.centerIn: parent
                        text: "S" + (index + 1)
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
                            if (parent.row < root.costMatrix.length) {
                                const current = matrixGrid.selectedCell;
                                matrixGrid.highlight(parent.row, (mouse.modifiers & Qt.ControlModifier && current) ? current.col : parent.col);
                            }
                        }
                    }
                }
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: matrixCHeader.bottom
            topMargin: matrixGrid.columnSpacing
            left: matrixRHeader.right
            leftMargin: matrixGrid.rowSpacing
            bottom: parent.bottom
            bottomMargin: -hScrollBar.anchors.bottomMargin
            right: parent.right
            rightMargin: -vScrollBar.anchors.rightMargin
        }

        ScrollBar.vertical: ScrollBar {
            id: vScrollBar
            width: 12
            policy: matrixGrid.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: -(width + matrixGrid.columnSpacing)
            }

            contentItem: Rectangle {
                radius: width / 2            // Bo tròn đầu
                color: vScrollBar.pressed ? "#999" : "#ccc"
            }
        }

        ScrollBar.horizontal: ScrollBar {
            id: hScrollBar
            height: 12
            policy: matrixGrid.width > width ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: -(height + matrixGrid.rowSpacing)
            }

            contentItem: Rectangle {
                radius: height / 2            // Bo tròn đầu
                color: hScrollBar.pressed ? "#999" : "#ccc"
            }
        }

        // Nội dung ma trận
        GridLayout {
            id: matrixGrid

            columns: root.costMatrix.length
            rows: root.costMatrix.length

            property var selectedCell: null

            Component {
                id: cellComponent
                Rectangle {
                    width: root.cellWidth
                    height: root.cellHeight
                    color: root.costMatrix && root.costMatrix[row][col] === 0 ? "transparent" : typeof root.costMatrix[row][col] !== "number" ? Theme.onFocus : "#f8f8f8"
                    radius: 3

                    property int col
                    property int row

                    Text {
                        visible: root.costMatrix && root.costMatrix[parent.row][parent.col] !== 0
                        anchors.centerIn: parent
                        text: {
                            var val = root.costMatrix[parent.row][parent.col];
                            if (typeof val === "number")
                                return val.toFixed(2);
                            return (val.dist + val.weight) === Infinity ? "Inf" : (val.dist + val.weight).toFixed(2);
                        }
                    }

                    Rectangle {
                        visible: matrixGrid.selectedCell && matrixGrid.selectedCell.row === parent.row ^ matrixGrid.selectedCell.col === parent.col
                        anchors.fill: parent
                        color: "black"
                        opacity: 0.3
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: matrixGrid.highlight(parent.row, parent.col)
                    }
                }
            }

            function highlight(row, col) {
                const last = matrixGrid.selectedCell?.row === row && matrixGrid.selectedCell?.col === col;
                matrixGrid.selectedCell = last ? null : {
                    row: row,
                    col: col
                };
            }

            function clear() {
                for (let k = matrixGrid.children.length - 1; k >= 0; k--) {
                    matrixGrid.children[k].destroy();
                }
            }

            function update() {
                clear();

                for (let i = 0; i < root.costMatrix.length; i++)
                    for (let j = 0; j < root.costMatrix[i].length; j++) {
                        const newCell = cellComponent.createObject(matrixGrid, {
                            row: i,
                            col: j
                        });
                    }
            }
        }
    }
}
