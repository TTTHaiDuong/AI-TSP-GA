import QtQuick
import QtQuick.Controls

Popup {
    id: root
    property string text: ""

    visible: false

    width: text.width + 10
    height: text.height + 6

    background: Rectangle {
        anchors.fill: parent
        color: "#333333"
        border.color: "#ffffff"
        border.width: 1
        radius: 4
        opacity: 0.9

        Text {
            id: text
            anchors.centerIn: parent
            color: "white"
            text: root.text
            font.pixelSize: 12
        }
    }
}
