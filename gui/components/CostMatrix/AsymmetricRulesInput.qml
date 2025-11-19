import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import ".."

ColumnLayout {
    id: root
    spacing: 0

    signal listUpdated

    onListUpdated: {
        Qt.callLater(() => AsymmetricRulesInputProps.rules = getAll());
    }

    function updateFromBridge() {
        _clear();
        if (AsymmetricRulesInputProps.rules)
            AsymmetricRulesInputProps.rules.forEach(r => _add(r));
        scrollView.contentItem.contentY = 0;
    }

    function getAll() {
        const rules = [];
        Utils.forEach(rulesContainer.children, c => {
            const rl = {
                order: c.order,
                start: c.start,
                end: c.end,
                forwardWeight: c.forwardWeight,
                backwardWeight: c.backwardWeight,
                directionType: c.directionType
            };
            rules.push(rl);
        });
        return rules;
    }

    function add(rule) {
        _add(rule);
        listUpdated();
    }

    function _add(rule) {
        const comp = Qt.createComponent("ARuleBar.qml");
        const item = comp.createObject(rulesContainer, {
            "Layout.fillWidth": true,
            "widths": widthModel.getWidths(),
            start: rule ? rule.start : 0,
            end: rule ? rule.end : 0,
            forwardWeight: rule ? rule.forwardWeight : 0,
            backwardWeight: rule ? rule.backwardWeight : 0,
            directionType: rule ? rule.directionType : 0
        });

        item.removeClicked.connect(remove);
        item.onStartChanged.connect(listUpdated);
        item.onEndChanged.connect(listUpdated);
        item.onForwardWeightChanged.connect(listUpdated);
        item.onBackwardWeightChanged.connect(listUpdated);
        item.onDirectionTypeChanged.connect(listUpdated);

        scrollView.scrollToBottom();
        Qt.callLater(() => rulesContainer.updateOrder());
    }

    function remove(order) {
        _remove(order);
        listUpdated();
    }

    function _remove(order) {
        Utils.forEach(rulesContainer.children, c => {
            if (c.order === order)
                c.destroy();
        });
        Qt.callLater(() => rulesContainer.updateOrder());
    }

    function clear() {
        _clear();
        listUpdated();
    }

    function _clear() {
        Utils.forEach(rulesContainer.children, c => {
            c.destroy();
        });
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: 40

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
            width: ruleColumns.width
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
                text: "Count: " + rulesContainer.children.length
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
        color: "transparent"

        ListModel {
            id: widthModel
            ListElement {
                w: 1.5
                name: "Order"
            }
            ListElement {
                w: 2.5
                name: "Start"
            }
            ListElement {
                w: 2.5
                name: "End"
            }
            ListElement {
                w: 2.7
                name: "Direction"
            }
            ListElement {
                w: 2.5
                name: "Forward weight"
            }
            ListElement {
                w: 2.5
                name: "Backward weight"
            }
            ListElement {
                w: 1.5
                name: ""
            }
            ListElement {
                w: 1.5
                name: ""
            }

            function getWidths() {
                const arr = [];
                for (let i = 0; i < widthModel.count; i++)
                    arr.push(widthModel.get(i).w);
                return arr;
            }
        }

        RowLayout {
            id: ruleColumns
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.min(parent.width, 700)

            Repeater {
                model: widthModel
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
                    }

                    MouseArea {
                        visible: index === 0
                        anchors.fill: parent
                        anchors.rightMargin: -10

                        property bool decrease
                        onClicked: decrease = !decrease
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

    ScrollView {
        id: scrollView
        Layout.preferredWidth: ruleColumns.width + scrollBar.width
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true

        function scrollToBottom() {
            if (scrollView.contentItem) {
                scrollView.contentItem.contentY = scrollView.contentItem.contentHeight;
            }
        }

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 12
            policy: rulesContainer.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        ColumnLayout {
            id: rulesContainer
            width: ruleColumns.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 3

            function updateOrder() {
                for (let i = 0; i < children.length; i++)
                    children[i].order = i + 1;
            }
        }
    }
}
