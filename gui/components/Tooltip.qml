import QtQuick

Rectangle {
    id: root
    visible: false
    color: "#333333"
    radius: 4
    opacity: 0.9
    z: 100
    border.color: "#ffffff"
    border.width: 1

    Text {
        id: tooltipText
        anchors.centerIn: parent
        color: "white"
        text: root.text
        font.pixelSize: 12
    }

    property string text: ""
    width: tooltipText.width + 10
    height: tooltipText.height + 6
}
