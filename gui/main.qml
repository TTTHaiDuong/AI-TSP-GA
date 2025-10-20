import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 200
    title: "Hello"

    Text {
        text: "Hello World!"
        anchors.centerIn: parent
        font.pointSize: 20
    }
}