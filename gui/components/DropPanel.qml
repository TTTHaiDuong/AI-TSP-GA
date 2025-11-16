import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// import QtQuick.Effects

Rectangle {
    id: root
    implicitWidth: parent ? parent.width : 300
    implicitHeight: header.implicitHeight + (expanded ? wrapContent.implicitHeight : 0)
    color: "transparent"
    clip: true

    property string title: "Menu"
    property bool expanded: true
    property int padding: 30
    property int spacing: 30

    default property alias contentChildren: contentArea.children

    // Header
    Button {
        id: header
        implicitHeight: 40
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1

        Rectangle {
            anchors.fill: parent
            color: "white"
            border.color: "#ececec"
            border.width: 1

            // Tựa đề
            Label {
                text: root.title
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            // Nút mũi tên
            Image {
                source: "../assets/drop_arrow.png"
                rotation: root.expanded ? 90 : 0
                fillMode: Image.PreserveAspectFit
                smooth: true
                layer.enabled: true

                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                width: 15
                height: 15

                Behavior on rotation {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }

        onClicked: root.expanded = !root.expanded
    }

    // MultiEffect {
    //     anchors.fill: header
    //     source: header
    //     shadowEnabled: true
    //     shadowColor: "#bfbfbf"
    //     shadowHorizontalOffset: -4
    //     shadowVerticalOffset: 1
    //     shadowBlur: 0.5

    //     Behavior on shadowEnabled {
    //         NumberAnimation {
    //             duration: 500
    //             easing.type: Easing.OutQuad
    //         }
    //     }
    // }

    // Bọc nội dung để padding
    Rectangle {
        id: wrapContent
        color: "transparent"
        implicitHeight: contentArea.implicitHeight + root.padding * 2
        anchors.top: header.bottom
        anchors.topMargin: root.expanded ? 0 : -implicitHeight
        anchors.left: parent.left
        anchors.right: parent.right
        visible: root.expanded

        // Nội dung chính
        ColumnLayout {
            id: contentArea
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: root.spacing
        }

        Behavior on anchors.topMargin {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
        }
    }
}
