import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import ".."

Drawer {
    id: root
    implicitWidth: parent.width - 70
    implicitHeight: parent.height
    modal: true
    edge: Qt.RightEdge
    topPadding: 0
    visible: true

    function getRules() {
        const rules = [];
        for (let i = 0; i < rulesContainer.children.length; i++) {
            const child = rulesContainer.children[i];
            rules.push([
                {
                    start: child.start,
                    end: child.end,
                    forwardWeight: child.forwardWeight,
                    backwardWeight: child.backwardWeight
                }
            ]);
        }
        return rules;
    }

    ColumnLayout {
        anchors {
            fill: parent
            topMargin: 40
            bottomMargin: 80
        }
        spacing: 0

        MaterialButton {
            id: rulesHeader
            Layout.fillWidth: true
            implicitHeight: 40
            pressScale: false

            Label {
                text: "Asymmetric Rules"
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: root.close()
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 40
            border.width: 1
            border.color: "#ececec"

            RowLayout {
                anchors.fill: parent

                MaterialButton {
                    implicitWidth: 60
                    implicitHeight: 30
                    radius: 8

                    Text {
                        text: "Add"
                        anchors.centerIn: parent
                    }

                    onClicked: {
                        // Tạo một ARuleBar mới và thêm vào ColumnLayout
                        rulesContainer.add();

                        scrollView.scrollToBottom();
                    }
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

                function add() {
                    var component = Qt.createComponent("ARuleBar.qml");
                    if (component.status === Component.Ready) {
                        var newRule = component.createObject(rulesContainer, {
                            "Layout.fillWidth": true,
                            "widths": widthModel.getWidths()
                        });
                        if (newRule === null) {
                            console.log("Failed to create ARuleBar");
                        } else {
                            newRule.removeClicked.connect(remove);
                        }
                    } else {
                        console.log("Component not ready:", component.errorString());
                    }

                    updateOrder();
                }

                function updateOrder() {
                    for (let i = 0; i < children.length; i++)
                        children[i].order = i;
                }

                function remove(order) {
                    for (let i = 0; i < children.length; i++) {
                        const child = children[i];
                        if (child.order === order)
                            child.destroy();
                    }
                    Qt.callLater(() => updateOrder());
                }
            }
        }
    }
}
