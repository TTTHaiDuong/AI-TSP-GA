import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

MaterialDropContent {
    id: root
    title: "Random Topology"
    expanded: RandTopologyProps.expanded
    onExpandedChanged: RandTopologyProps.expanded = expanded

    signal generateTopology(int cities, int seed)

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

            // --- Nodes SpinBox ---
            ColumnLayout {
                width: 100
                spacing: 0

                Label {
                    text: "Cities"
                }
                MaterialSpinBox {
                    id: nodeCount
                    from: 5
                    to: 200
                    value: RandTopologyProps.citiesNum
                    onValueChanged: RandTopologyProps.citiesNum = value
                }
            }

            // --- Seed SpinBox ---
            ColumnLayout {
                width: 100
                spacing: 0

                Item {
                    implicitHeight: 16
                    z: 1

                    CheckBox {
                        id: seedCheck
                        z: 10
                        text: "Seed"
                        Material.accent: Theme.onFocus
                        padding: 0
                        verticalPadding: 0
                        checked: RandTopologyProps.useSeed
                        onCheckedChanged: RandTopologyProps.useSeed = checked
                    }
                }
                MaterialSpinBox {
                    id: seedInput
                    from: 0
                    to: 9999
                    enabled: seedCheck.checked
                    value: RandTopologyProps.seed
                    onValueChanged: RandTopologyProps.seed = value
                    grayedOut: !enabled
                }
            }

            ColumnLayout {
                width: 100
                spacing: 0

                Item {
                    implicitHeight: 16
                }
                MaterialButton {
                    id: generate
                    implicitWidth: 100
                    implicitHeight: 30
                    text: "Generate"
                    radius: 8

                    onClicked: {
                        RandTopologyProps.generateClicked = !RandTopologyProps.generateClicked;
                    }
                }
            }
        }

        Connections {
            target: RandTopologyProps

            function onExpandedUpdate(v) {
                root.expanded = v;
            }
            function onCitiesNumUpdate(v) {
                nodeCount.value = v;
            }
            function onUseSeedUpdate(v) {
                seedCheck.checked = v;
            }
            function onSeedUpdate(v) {
                seedInput.value = v;
            }
        }
    }
}
