import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: root

    property var algorithms: ["Genetic", "PSO", "ACO", "SA", "Held-Karp"]
    property var states: [true, true, true, false, false]
    property var reasons: ["", "", "", "Over time", "Unspecified"]
    onStatesChanged: {
        for (let i = 0; i < algorithms.length; i++) {
            const newBar = barComponent.createObject(root, {
                pass: states && states[i],
                name: algorithms[i],
                reason: reasons && reasons[i]
            });
        }
    }

    Component {
        id: barComponent

        Rectangle {
            id: bar
            radius: 8
            color: pass ? "#1eff00" : Theme.unFocus
            Layout.fillWidth: true
            implicitHeight: 17

            property bool pass
            property string name
            property string reason

            RowLayout {
                anchors.fill: parent

                Text {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    elide: Qt.ElideRight
                    text: bar.pass ? "✓" : "✕"
                    color: bar.pass ? "black" : "red"
                }

                Text {
                    Layout.preferredWidth: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Qt.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    text: bar.name
                }

                Text {
                    Layout.preferredWidth: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Qt.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    text: bar.reason
                }
            }
        }
    }
}
