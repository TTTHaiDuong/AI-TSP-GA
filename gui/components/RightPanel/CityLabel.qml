import QtQuick 2.15

Item {
    id: root
    property int index: 0

    Text {
        text: (root.index + 1).toString()
        color: "#FFA500"
        font.pixelSize: 14
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }
}
