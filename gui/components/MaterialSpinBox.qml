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
    property int style: 0

    implicitWidth: 100
    implicitHeight: 30

    // Hiệu ứng grayed out
    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: root.grayedOut ? 0.6 : 0
    }

    // Đường viền dưới
    background: Item {
        anchors.fill: parent

        Rectangle {
            visible: root.style === 0
            height: 1
            color: Theme.unFocus
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                rightMargin: indicator.anchors.rightMargin
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

        Rectangle {
            visible: root.style === 1
            anchors.fill: parent
            border.width: 1
            border.color: Theme.unFocus
            radius: 4

            Rectangle {
                visible: inputField.activeFocus && !root.grayedOut
                anchors.fill: parent
                border.width: 2
                border.color: Theme.onFocus
                radius: parent.radius

                Behavior on visible {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }
    }

    contentItem: Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Hiển thị giá trị chính
        TextField {
            id: inputField
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: indicator.left
                rightMargin: 4
            }

            text: root.value
            color: activeFocus && !root.grayedOut ? Theme.onFocus : "#222222"
            font.pixelSize: 14
            horizontalAlignment: root.style === 0 ? TextEdit.AlignLeft : TextEdit.AlignHCenter
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
            anchors.rightMargin: 10
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

    // Lăn chuột để tăng giảm giá trị
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
