import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

ColumnLayout {
    id: root
    spacing: 0

    signal inputClicked

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

    // ScrollView danh sách menu drop (Random Topology, Variables)
    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ScrollBar.vertical: ScrollBar {
            width: 12
            policy: dropPanelList.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        ColumnLayout {
            id: dropPanelList
            width: parent.parent.width
            spacing: 0

            RandomTopology {
                Layout.fillWidth: true
            }

            Variables {
                Layout.fillWidth: true
            }
        }
    }
}
