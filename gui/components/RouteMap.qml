import QtQuick

Item {
    id: root
    property string title

    Chart {
        title: root.title
        anchors.fill: parent
    }
}
