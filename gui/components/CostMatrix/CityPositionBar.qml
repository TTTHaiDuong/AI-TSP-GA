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

    property real xPos
    property real yPos

    onXPosChanged: xPosSpin.value = xPos
    onYPosChanged: yPosSpin.value = yPos

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
                id: xPosSpin
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
                style: 1
                onValueChanged: root.xPos = value
                from: 0
                to: 10
            }
        }

        // Điểm kết thúc
        Rectangle {
            Layout.preferredWidth: root.widths.length > 2 ? root.widths[2] : 60
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            MaterialSpinBox {
                id: yPosSpin
                anchors.centerIn: parent
                width: Math.min(80, parent.width)
                style: 1
                onValueChanged: root.yPos = value
                from: 0
                to: 10
            }
        }

        // Nút thay đổi vị trí
        Rectangle {
            Layout.preferredWidth: root.widths.length > 3 ? root.widths[3] : 40
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
            Layout.preferredWidth: root.widths.length > 4 ? root.widths[4] : 50
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
