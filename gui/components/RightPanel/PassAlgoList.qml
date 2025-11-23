import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: root
    spacing: 10

    property var algorithms: ["Genetic", "BCO", "ACO", "SA", "Held-Karp"]
    property var states: [true, true, true, true, true]
    property var col1: ["", "", "", "", ""]
    property var col2
    property int currentIndex
    property var layoutRatio: [1, 2, 3, 2]

    onStatesChanged: {
        Qt.callLater(() => {
            for (let i = -1; i < algorithms.length; i++) {
                const barProps = i !== -1 ? {
                    currentIndex: i
                } : {
                    currentIndex: -1,
                    color: "#cccccc",
                    col1: "Best cost",
                    col2: "Error (%)"
                };
                const newBar = barComponent.createObject(root, barProps);
            }
        });
    }

    Component {
        id: barComponent

        Rectangle {
            id: bar
            radius: 8
            color: pass ? (root.currentIndex === currentIndex ? Theme.onFocus : Theme.primaryLight) : Theme.unFocus
            Layout.fillWidth: true
            implicitHeight: 40

            property bool pass: root.states && root.states[currentIndex] ? root.states[currentIndex] : ""
            property string name: root.algorithms && root.algorithms[currentIndex] ? root.algorithms[currentIndex] : ""
            property string col1: root.col1 && root.col1[currentIndex] ? root.col1[currentIndex] : ""
            property string col2: root.col2 && root.col2[currentIndex] ? root.col2[currentIndex] : ""
            property int currentIndex

            MouseArea {
                anchors.fill: parent
                onClicked: root.currentIndex = bar.currentIndex
            }

            RowLayout {
                anchors.fill: parent

                Text {
                    Layout.preferredWidth: root.layoutRatio[0]
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Qt.ElideRight
                    text: bar.currentIndex >= 0 ? (bar.pass ? "✓" : "✕") : ""
                    color: bar.pass ? "black" : "red"
                }

                Text {
                    Layout.preferredWidth: root.layoutRatio[1]
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    text: bar.name
                }

                Text {
                    Layout.preferredWidth: root.layoutRatio[2]
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    text: bar.col1
                }

                Text {
                    Layout.preferredWidth: root.layoutRatio[3]
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    elide: Qt.ElideRight
                    text: bar.col2
                }
            }
        }
    }
}
