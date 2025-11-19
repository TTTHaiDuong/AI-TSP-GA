import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    implicitHeight: 50
    color: "#f8f8f8"
    radius: 8

    property int order
    property var widths

    property int start
    property int end
    property real forwardWeight
    property real backwardWeight
    property int directionType

    onStartChanged: startSpin.value = start
    onEndChanged: endSpin.value = end
    onForwardWeightChanged: forwardWeightSpin.value = forwardWeight
    onBackwardWeightChanged: backwardWeightSpin.value = backwardWeight
    onDirectionTypeChanged: toggleBtn.type = directionType

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
                text: root.order
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
                id: startSpin
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
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
                id: endSpin
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
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
                width: Math.min(50, parent.width)
                height: 35
                onTypeChanged: root.directionType = type
            }
        }

        // Trọng số đi vào điểm bắt đầu
        Rectangle {
            Layout.preferredWidth: root.widths.length > 4 ? root.widths[4] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            MaterialSpinBox {
                id: forwardWeightSpin
                visible: [1, 2].includes(toggleBtn.type)
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
                style: 1
                onValueChanged: root.forwardWeight = value
            }

            InfLabel {
                width: Math.min(80, parent.width)
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
                id: backwardWeightSpin
                visible: [0, 2].includes(toggleBtn.type)
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
                style: 1
                onValueChanged: root.backwardWeight = value
            }

            InfLabel {
                width: Math.min(80, parent.width)
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
