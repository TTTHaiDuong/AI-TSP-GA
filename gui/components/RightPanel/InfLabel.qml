import QtQuick
import ".."

Rectangle {
    anchors.centerIn: parent
    width: 60
    height: 30
    radius: 8
    color: Theme.unFocus
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -implicitHeight / 10
        text: "∞"
        font.pixelSize: 25
        color: "white"
    }
}
