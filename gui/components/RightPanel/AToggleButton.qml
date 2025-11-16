import QtQuick
import ".."

MaterialButton {
    id: root
    property var symbolsMap: {
        0: "→",
        1: "←",
        2: "↔",
        3: "×"
    }
    property int type: 0
    radius: 8

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -implicitHeight / 10

        text: root.symbolsMap[root.type]
        font.pixelSize: 30
        color: root.type !== 3 ? Theme.onFocus : "red"
    }

    onClicked: {
        type = (type + 1) % 4;
    }
}
