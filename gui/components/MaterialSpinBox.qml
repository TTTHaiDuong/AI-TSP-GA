import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    id: root
    property int from: 0
    property int to: 9999
    property double value: 0
    property double step: 1
    property bool grayedOut

    implicitWidth: 100
    implicitHeight: 30

    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: root.grayedOut ? 0.6 : 0
    }

    // Đường viền dưới
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
            width: inputField.activeFocus && !root.grayedOut ? parent.width : 0
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

    contentItem: Rectangle {
        anchors.fill: parent
        color: "transparent"

        TextField {
            id: inputField
            anchors.left: parent.left
            anchors.right: indicator.left
            anchors.rightMargin: 8

            text: root.value
            color: activeFocus && !root.grayedOut ? Theme.onFocus : "#222222"
            font.pixelSize: 14
            horizontalAlignment: TextEdit.AlignLeft
            verticalAlignment: TextEdit.AlignVCenter
            inputMethodHints: Qt.ImhDigitsOnly
            leftPadding: 0

            background: null

            validator: DoubleValidator {
                bottom: root.from
                top: root.to
            }

            onEditingFinished: {
                const onlyNums = text.replace(/,/g, "");
                root.value = parseFloat(onlyNums || "0");
            }
        }

        // Các nút mũi tên
        ColumnLayout {
            id: indicator
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: 0

            Text {
                text: "▲"
                font.pixelSize: 8
                color: Theme.unFocus

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.increase()
                    onPressed: parent.color = Theme.onFocus
                    onReleased: parent.color = Theme.unFocus
                }
            }

            Text {
                text: "▼"
                font.pixelSize: 8
                color: Theme.unFocus

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.decrease()
                    onPressed: parent.color = Theme.onFocus
                    onReleased: parent.color = Theme.unFocus
                }
            }
        }
    }

    WheelHandler {
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                root.increase();
            else if (wheel.angleDelta.y < 0)
                root.decrease();
        }
    }

    function increase() {
        if (value < to)
            value = Math.round((value + step) * 100) / 100;
    }

    function decrease() {
        if (value > from)
            value = Math.round((value - step) * 100) / 100;
    }

    onValueChanged: {
        if (value > to)
            value = to;
        if (value < from)
            value = from;
    }
}
