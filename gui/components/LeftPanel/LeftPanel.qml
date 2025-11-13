import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

ColumnLayout {
    id: root
    spacing: 0

    signal inputClicked
    signal generateTopology(int citiesNum, var seed)

    // Dãy có chữ Input
    MaterialButton {
        id: inputHeader
        Layout.fillWidth: true
        implicitHeight: 40
        pressScale: false

        Label {
            text: "Input"
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        onClicked: root.inputClicked()
    }

    // Scroll view cho danh sách menu drop (Random Topology, Variables)
    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ScrollBar.vertical: ScrollBar {
            width: 12
            policy: dropMenuList.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        // Danh sách các menu drop
        ColumnLayout {
            id: dropMenuList
            width: parent.parent.width
            spacing: 0

            RandomTopology {
                Layout.fillWidth: true
                onGenerateTopology: root.generateTopology
            }

            // Menu drop Variables
            Variables {
                Layout.fillWidth: true
            }
        }
    }
}
