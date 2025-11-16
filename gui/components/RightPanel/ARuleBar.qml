import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

Rectangle {
    id: root
    implicitHeight: 50
    // border.width: 1
    color: "#f8f8f8"
    radius: 8

    property int order: 1
    property var widths

    property int start
    property int end
    property double forwardWeight
    property double backwardWeight

    signal removeClicked(int order)

    RowLayout {
        anchors.fill: parent

        // Thứ tự
        Rectangle {
            Layout.preferredWidth: root.widths.length > 0 ? root.widths[0] : 40
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: root.order + 1
                font.bold: true
            }
        }

        // Điểm bắt đầu
        Rectangle {
            Layout.preferredWidth: root.widths.length > 1 ? root.widths[1] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            MaterialSpinBox {
                anchors.centerIn: parent
                width: 60
                style: 1
                onValueChanged: root.start = value
            }
        }

        // Điểm kết thúc
        Rectangle {
            Layout.preferredWidth: root.widths.length > 2 ? root.widths[2] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            MaterialSpinBox {
                anchors.centerIn: parent
                width: 60
                style: 1
                onValueChanged: root.end = value
            }
        }

        // Nút thay đổi hướng của cạnh
        Rectangle {
            Layout.preferredWidth: root.widths.length > 3 ? root.widths[3] : 35
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            AToggleButton {
                id: toggleBtn
                anchors.centerIn: parent
                width: 35
                height: 35
            }
        }

        // Trọng số đi vào điểm bắt đầu
        Rectangle {
            Layout.preferredWidth: root.widths.length > 4 ? root.widths[4] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            MaterialSpinBox {
                visible: [1, 2].includes(toggleBtn.type)
                anchors.centerIn: parent
                width: 60
                style: 1
                onValueChanged: root.forwardWeight = value
            }

            InfLabel {
                visible: [0, 3].includes(toggleBtn.type)
            }
        }

        // Trọng số đi vào điểm kết thúc
        Rectangle {
            Layout.preferredWidth: root.widths.length > 5 ? root.widths[5] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            MaterialSpinBox {
                visible: [0, 2].includes(toggleBtn.type)
                anchors.centerIn: parent
                width: 60
                style: 1
                onValueChanged: root.backwardWeight = value
            }

            InfLabel {
                visible: [1, 3].includes(toggleBtn.type)
            }
        }

        // Nút thay đổi vị trí
        Rectangle {
            Layout.preferredWidth: root.widths.length > 6 ? root.widths[6] : 40
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            Text {
                text: "▲▼"
                color: Theme.unFocus
                anchors.centerIn: parent
                font.pixelSize: 10
            }
        }

        // Nút xoá
        Rectangle {
            Layout.preferredWidth: root.widths.length > 7 ? root.widths[7] : 50
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            MaterialButton {
                anchors.centerIn: parent
                width: 32
                height: 32
                bgColor: "transparent"
                radius: 6

                onClicked: root.removeClicked(root.order)

                Text {
                    text: "✕"
                    anchors.centerIn: parent
                    font.pixelSize: 14
                }
            }
        }
    }
}
