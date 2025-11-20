import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

RowLayout {
    id: root
    implicitHeight: 160

    property bool useSeed: seedCheck.checked
    property int seed: seedInput.value
    property real bestCost
    property real time
    property real memory

    signal run

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        MaterialButton {
            id: runBtn
            width: 100
            height: 40
            radius: 8
            bgColor: "#6e6e6e"
            anchors.centerIn: parent

            Label {
                text: "Solve"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }

            onClicked: root.run()
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Slider {
                id: slider
                from: 1
                to: 1000
                value: 50
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.verticalCenter: parent.verticalCenter
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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 16
                            z: 1

                            CheckBox {
                                id: seedCheck
                                text: "Seed"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                z: 10
                            }
                        }
                        MaterialSpinBox {
                            id: seedInput
                            from: 0
                            to: 9999
                            enabled: seedCheck.checked
                            grayedOut: !enabled
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.centerIn: parent

                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 16
                            z: 1

                            CheckBox {
                                id: earlyStoppingCheck
                                anchors.left: parent.left
                                anchors.right: parent.right
                                text: "Early Stopping (epoch)"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                z: 10
                            }
                        }
                        MaterialSpinBox {
                            id: earlyStoppingInput
                            from: 0
                            to: 9999
                            enabled: earlyStoppingCheck.checked
                            grayedOut: !enabled
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    Layout.fillHeight: true
                    clip: true

                    Text {
                        id: bestCostTitle
                        text: "Best Cost"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: root.bestCost
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Layout.fillHeight: true
                    clip: true

                    Text {
                        id: timeTitle
                        text: "Time"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: root.time
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    Text {
                        id: memoryTitle
                        text: "Memory"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: root.memory
                    }
                }
            }
        }
    }
}
