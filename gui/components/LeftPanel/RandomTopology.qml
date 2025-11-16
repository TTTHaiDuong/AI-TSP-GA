import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

DropPanel {
    id: root
    title: "Random Topology"
    expanded: RandTopologyProps.expanded
    onExpandedChanged: RandTopologyProps.expanded = expanded

    signal generateTopology(int citiesNum, int seed)

    ColumnLayout {
        spacing: 30

        Item {
            implicitHeight: description.implicitHeight
            Label {
                id: description
                text: "Khởi tạo các điểm.\nNhấn vào nút \"Generate\" để sử dụng chức năng sinh ngẫu nhiên\nhoặc thao tác trực tiếp trên Route Map."
                wrapMode: Text.WordWrap
                width: root.implicitWidth - 2 * root.padding
            }
        }

        Flow {
            Layout.fillWidth: true
            spacing: 30

            // Nhập số lượng thành phố
            ColumnLayout {
                width: 100
                spacing: 0

                Label {
                    text: "Cities"
                }
                MaterialSpinBox {
                    id: citiesNumInput
                    from: 5
                    to: 200
                    value: RandTopologyProps.citiesNum
                    onValueChanged: RandTopologyProps.citiesNum = value
                }
            }

            // Nhập random seed
            ColumnLayout {
                width: 100
                spacing: 0

                Item {
                    implicitHeight: 16
                    z: 1

                    CheckBox {
                        id: seedCheckBox
                        text: "Seed"
                        Material.accent: Theme.onFocus
                        padding: 0
                        verticalPadding: 0
                        z: 10
                        checked: RandTopologyProps.useSeed
                        onCheckedChanged: RandTopologyProps.useSeed = checked
                    }
                }
                MaterialSpinBox {
                    id: seedInput
                    from: 0
                    to: 9999
                    enabled: seedCheckBox.checked
                    grayedOut: !enabled
                    value: RandTopologyProps.seed
                    onValueChanged: RandTopologyProps.seed = value
                }
            }

            // Nút khởi tạo
            ColumnLayout {
                width: 100
                spacing: 0

                Item {
                    implicitHeight: 16
                }
                MaterialButton {
                    text: "Generate"
                    implicitWidth: 100
                    implicitHeight: 30
                    radius: 8

                    onClicked: RandTopologyProps.generateBtnClicked()
                }
            }
        }

        Connections {
            target: RandTopologyProps
            onExpandedChanged: root.expanded = RandTopologyProps.expanded
            onCitiesNumChanged: citiesNumInput.value = RandTopologyProps.citiesNum
            onUseSeedChanged: seedCheckBox.value = RandTopologyProps.useSeed
            onSeedChanged: seedInput.value = RandTopologyProps.seed
        }
    }
}
