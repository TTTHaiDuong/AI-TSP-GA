import QtQuick
import QtQuick.Controls

ComboBox {
    id: root
    implicitWidth: 160
    implicitHeight: 30
    font.pixelSize: 14

    // Đường viền phía dưới
    background: Rectangle {
        height: 1
        color: Theme.unFocus
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // Hiệu ứng khi focus
        Rectangle {
            width: root.activeFocus ? parent.width : 0
            height: 2
            color: Theme.onFocus
            radius: 1
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on width {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }

    // Nội dung
    contentItem: Text {
        text: root.displayText
        font: root.font
        color: root.activeFocus ? Theme.onFocus : "#222222"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        leftPadding: 0
        anchors.left: parent.left
    }

    indicator: Text {
        text: "▼"
        font.pixelSize: 8
        width: 8
        height: 8
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: root.activeFocus ? Theme.onFocus : Theme.unFocus
    }
}
