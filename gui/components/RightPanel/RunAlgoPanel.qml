import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

GridLayout {
    id: root
    columns: 2
    rows: 2
    rowSpacing: 0

    property bool useSeed: seedCheck.checked
    property int seed: seedInput.value
    property var bestCosts
    property real time
    property real memory
    property int sliderValue: Math.round(slider.value)

    signal run
    signal clear

    Item {
        Layout.preferredWidth: 1
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

    Item {
        Layout.preferredWidth: 4
        Layout.fillWidth: true
        Layout.fillHeight: true

        Slider {
            id: slider
            from: 1
            to: root.bestCosts ? root.bestCosts.length : 1
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            height: 20
            Material.accent: root.bestCosts ? Theme.onFocus : Theme.unFocus

            onToChanged: {
                if (root.bestCosts)
                    slider.value = Math.min(root.bestCosts.length, slider.to);
                else
                    slider.value = slider.from;
            }

            Rectangle {
                implicitWidth: 100
                color: "#ffffffff"
                radius: 8
                anchors.bottom: parent.top
                anchors.bottomMargin: 20
                Label {
                    text: root.bestCosts ? ("Iteration " + Math.round(slider.value) + "/" + slider.to) : "Iteration __ /__"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }
            }

            MouseArea {
                id: blockInteraction
                anchors.fill: parent
                acceptedButtons: root.bestCosts ? Qt.NoButton : Qt.AllButtons
                hoverEnabled: true

                onPositionChanged: {
                    if (slider.to <= slider.from)
                        return;

                    sliderTooltip.visible = true;

                    let ratio = mouse.x / width;
                    ratio = Math.max(0, Math.min(1, ratio)); // clamp 0..1

                    let valueAtMouse = slider.from + ratio * (slider.to - slider.from);

                    sliderTooltip.text = Math.round(valueAtMouse);
                    sliderTooltip.x = mouse.x - sliderTooltip.width / 2;
                    sliderTooltip.y = slider.handle.y - sliderTooltip.height - 8;
                }

                onExited: {
                    sliderTooltip.visible = false;
                }
            }

            Tooltip {
                id: sliderTooltip
                visible: false
            }

            Tooltip {
                visible: slider.pressed
                y: slider.handle.y - height - 8
                x: slider.handle.x + slider.handle.width / 2 - width / 2
                text: Math.round(slider.value)
            }
        }
    }

    Item {
        Layout.preferredWidth: 1
        Layout.fillWidth: true
        Layout.fillHeight: true

        MaterialButton {
            anchors.centerIn: parent
            width: 32
            height: 32
            bgColor: "transparent"
            radius: 8

            Image {
                source: "../../assets/clear.svg"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                anchors.margins: 4
            }

            onClicked: {
                root.bestCosts = undefined;
                root.time = 0;
                root.memory = 0;
                root.clear();
            }
        }
    }

    RowLayout {
        Layout.preferredWidth: 4
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                width: 100
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                CheckBox {
                    id: seedCheck
                    text: "Seed"
                    Material.accent: Theme.onFocus
                    padding: 0
                    verticalPadding: 0
                    z: 10
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 16
                }
                MaterialSpinBox {
                    id: seedInput
                    from: 0
                    to: 9999
                    style: 1
                    enabled: seedCheck.checked
                    grayedOut: !enabled
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                id: benchContainer
                anchors.fill: parent
                spacing: 0

                property bool narrow: width < 275

                Column {
                    Text {
                        id: bestCostTitle
                        text: benchContainer.narrow ? "C" : "Best Cost"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: root.bestCosts && root.bestCosts[root.sliderValue - 1] !== undefined ? root.bestCosts[root.sliderValue - 1].toFixed(3) : "___"
                    }
                }

                Column {
                    Text {
                        id: timeTitle
                        text: benchContainer.narrow ? "T" : "Time"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                        anchors.left: parent.left
                    }
                    Text {
                        text: root.time ? root.time.toFixed(4) + " s" : "___"
                    }
                }

                Column {
                    Text {
                        id: memoryTitle
                        text: benchContainer.narrow ? "M" : "Memory"
                        font.bold: true
                        font.pixelSize: 20
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: root.memory ? root.memory + " KB" : "___"
                    }
                }
            }
        }
    }
}
