import QtQuick
import QtQuick.Layouts
import ".."

MaterialButton {
    id: root
    implicitWidth: 120
    implicitHeight: 50
    radius: 8
    bgColor: "#6e6e6e"

    property int currentState

    signal run
    signal stop
    signal reset

    onClicked: {
        if (currentState === 0) {
            run();
            currentState = 1;
        } else if (currentState === 1) {
            stop();
            currentState = 0;
        } else if (currentState === 2) {
            reset();
            currentState = 0;
        }
    }

    RowLayout {
        anchors.fill: parent

        Text {
            text: ["Run", "Stop", "Reset"][root.currentState]
            color: "white"
            font.bold: true
            font.pixelSize: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.5
            Layout.fillWidth: true
            horizontalAlignment: root.currentState === 1 ? Text.AlignRight : Text.AlignHCenter
        }

        Item {
            visible: root.currentState === 1
            Layout.preferredWidth: root.currentState === 1 ? 0.5 : 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                source: "../../assets/load.svg"
                width: 24
                height: 24
                anchors.centerIn: parent
                antialiasing: true
                smooth: true

                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 500
                    loops: Animation.Infinite
                    running: true
                }
            }
        }
    }
}
