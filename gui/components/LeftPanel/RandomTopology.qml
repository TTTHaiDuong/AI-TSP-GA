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
            spacing: 40

            // Nhập số lượng thành phố
            Column {
                width: 100

                Label {
                    text: "Cities"
                }
                MaterialSpinBox {
                    id: citiesNumInput
                    anchors.left: parent.left
                    anchors.right: parent.right
                    from: 5
                    to: 200
                    value: RandTopologyProps.citiesNum
                    onValueChanged: RandTopologyProps.citiesNum = value
                }
            }

            // Nhập random seed
            Column {
                width: 100

                CheckBox {
                    id: seedCheckBox
                    text: "Seed"
                    Material.accent: Theme.onFocus
                    padding: 0
                    verticalPadding: 0
                    height: 16
                    z: 10
                    checked: RandTopologyProps.useSeed
                    onCheckedChanged: RandTopologyProps.useSeed = checked
                }
                MaterialSpinBox {
                    id: seedInput
                    anchors.left: parent.left
                    anchors.right: parent.right
                    from: 0
                    to: 9999
                    enabled: seedCheckBox.checked
                    grayedOut: !enabled
                    value: RandTopologyProps.seed
                    onValueChanged: RandTopologyProps.seed = value
                }
            }

            // Nút khởi tạo
            Column {
                width: 100

                Item {
                    width: 1
                    height: 16
                }
                MaterialButton {
                    text: "Generate"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 30
                    radius: 8

                    onClicked: {
                        const cities = routeBridge.randomize(citiesNumInput.value, seedCheckBox.checked ? seedInput.value : -1);
                        CitiesInputProps.cities = cities;
                    }
                }
            }
        }

        Connections {
            target: RandTopologyProps

            function onExpandedChanged() {
                root.expanded = RandTopologyProps.expanded;
            }
            function onCitiesNumChanged() {
                citiesNumInput.value = RandTopologyProps.citiesNum;
            }
            function onUseSeedChanged() {
                seedCheckBox.checked = RandTopologyProps.useSeed;
            }
            function onSeedChanged() {
                seedInput.value = RandTopologyProps.seed;
            }
        }

        Connections {
            target: routeBridge
        }
    }
}
