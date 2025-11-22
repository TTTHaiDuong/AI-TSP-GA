import QtQuick

MaterialButton {
    id: root
    width: 26
    height: 26
    bgColor: "transparent"
    radius: 8

    property bool value

    Image {
        source: root.value ? "../assets/eye.svg" : "../assets/eye-off.svg"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        anchors.margins: 2
    }

    onClicked: value = !value
}
