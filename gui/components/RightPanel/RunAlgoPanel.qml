import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../LeftPanel"
import "../Bridge"
import "../Comparison"
import ".."

Item {
    id: root
    implicitHeight: 160

    signal run

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 50

        RowLayout {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 30

            MaterialButton {
                id: runBtn
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 100
                implicitHeight: 40
                radius: 8
                bgColor: "#6e6e6e"
                Label {
                    text: "Solve"
                    color: "white"
                    font.bold: true
                    anchors.centerIn: parent
                }

                onClicked: root.run()
            }

            Slider {
                id: slider
                from: 1
                to: 1000
                value: 50
                Layout.fillWidth: true
                Material.accent: Theme.onFocus

                Rectangle {
                    implicitWidth: 100
                    color: "#ffffffff"
                    radius: 8
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 5
                    Label {
                        text: "Epoch " + Math.round(slider.value) + "/" + slider.to + " (Early Stopping)"
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                    }
                }

                onValueChanged:
                // console.log("Giá trị Slider:", value);
                {}

                // MouseArea {
                //     id: hoverArea
                //     anchors.fill: parent
                //     hoverEnabled: true
                //     onPositionChanged: {
                //         // Tính toán giá trị tương ứng theo vị trí chuột
                //         let rel = Math.max(0, Math.min(1, mouse.x / width));
                //         slider.value = slider.from + rel * (slider.to - slider.from);
                //     }
                // }

                Tooltip {
                    id: sliderTooltip
                    visible: slider.pressed
                    y: slider.handle.y - height - 6
                    x: slider.handle.x + slider.handle.width / 2 - width / 2
                    text: Math.round(slider.value)
                }
            }
        }
    }
}
