import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

ColumnLayout {
    id: root
    spacing: 0

    signal listUpdated

    onListUpdated: {
        Qt.callLater(() => CitiesInputProps.cities = getAll());
    }

    function updateFromBridge() {
        _clear();
        if (CitiesInputProps.cities)
            CitiesInputProps.cities.forEach(c => _add(c.x, c.y));
        scrollView.contentItem.contentY = 0;
    }

    function getAll() {
        const cities = [];
        Utils.forEach(citiesContainer.children, c => {
            const pt = {
                order: c.order,
                x: c.xPos,
                y: c.yPos
            };
            cities.push(pt);
        });
        return cities;
    }

    function add(x = 0, y = 0) {
        _add(x, y);
        listUpdated();
    }

    function _add(x = 0, y = 0) {
        const comp = Qt.createComponent("CityPositionBar.qml");
        const item = comp.createObject(citiesContainer, {
            "Layout.fillWidth": true,
            widths: widthCityModel.getWidths(),
            xPos: x,
            yPos: y
        });

        item.removeClicked.connect(remove);
        item.onXPosChanged.connect(listUpdated);
        item.onYPosChanged.connect(listUpdated);

        scrollView.scrollToBottom();
        Qt.callLater(() => citiesContainer.updateOrder());
    }

    function remove(order) {
        _remove(order);
        listUpdated();
    }

    function _remove(order) {
        Utils.forEach(citiesContainer.children, c => {
            if (c.order === order)
                c.destroy();
        });
        Qt.callLater(() => citiesContainer.updateOrder());
    }

    function clear() {
        _clear();
        listUpdated();
    }

    function _clear() {
        Utils.forEach(citiesContainer.children, c => {
            c.destroy();
        });
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: 40

        // Đường viền trên tiêu đề danh sách toạ độ
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: Theme.unFocus
            height: 1
        }

        RowLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: header.width
            layoutDirection: Qt.RightToLeft

            MaterialButton {
                implicitWidth: 60
                implicitHeight: 30
                radius: 8

                Text {
                    text: "Add"
                    anchors.centerIn: parent
                }

                onClicked: {
                    root.add();
                }
            }

            Text {
                text: "Count: " + citiesContainer.children.length
            }
        }
    }

    // Tiêu đề
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
        color: "transparent"

        ListModel {
            id: widthCityModel
            ListElement {
                w: 1
                name: "ID"
            }
            ListElement {
                w: 2
                name: "X"
            }
            ListElement {
                w: 2
                name: "Y"
            }
            ListElement {
                w: 1
                name: ""
            }
            ListElement {
                w: 1
                name: ""
            }

            function getWidths() {
                const arr = [];
                for (let i = 0; i < widthCityModel.count; i++)
                    arr.push(widthCityModel.get(i).w);
                return arr;
            }
        }

        RowLayout {
            id: header
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.min(parent.width, 350)

            Repeater {
                model: widthCityModel
                Rectangle {
                    Layout.preferredWidth: model.w
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    Text {
                        text: model.name
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideMiddle
                        width: parent.width

                        MouseArea {
                            visible: index === 0
                            anchors.fill: parent

                            property bool decrease
                            onClicked: {
                                decrease = !decrease;
                                citiesContainer.reverse(decrease);
                            }
                            Text {
                                text: parent.decrease ? "▲" : "▼"
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                color: Theme.unFocus
                            }
                        }
                    }
                }
            }
        }
    }

    ScrollView {
        id: scrollView
        Layout.preferredWidth: header.width + cscrollBar.width
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true

        function scrollToBottom() {
            if (scrollView.contentItem) {
                scrollView.contentItem.contentY = scrollView.contentItem.contentHeight;
            }
        }

        ScrollBar.vertical: ScrollBar {
            id: cscrollBar
            width: 12
            policy: citiesContainer.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        ColumnLayout {
            id: citiesContainer
            width: header.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 3

            function reverse(reverse) {
                const n = children.length;
                for (let i = 0; i < n; i++) {
                    if (children[i].Layout === undefined)
                        console.log("BB");
                    children[i].Layout.index = reverse ? n - 1 - i     // hiển thị ngược
                    : i;            // hiển thị xuôi
                }
            }

            function updateOrder() {
                for (let i = 0; i < children.length; i++)
                    children[i].order = i + 1;
            }
        }
    }
}
