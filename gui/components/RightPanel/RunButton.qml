import QtQuick
import QtQuick.Layouts
import ".."

MaterialButton {
    id: root
    implicitWidth: 120
    implicitHeight: 40
    radius: 8
    bgColor: "#6e6e6e"

    property bool currentState

    signal run
    signal stop

    onClicked: {
        run();

        // currentState = !currentState;
        // if (currentState) {
        //     run();
        // } else {
        //     stop();
        // }
    }

    RowLayout {
        anchors.fill: parent

        Text {
            text: root.currentState ? "Stop" : "Run"
            color: "white"
            font.bold: true
            font.pixelSize: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.5
            Layout.fillWidth: true
            horizontalAlignment: root.currentState ? Text.AlignRight : Text.AlignHCenter
        }

        Item {
            visible: root.currentState
            Layout.preferredWidth: root.currentState ? 0.5 : 0
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
                    duration: 2000
                    loops: Animation.Infinite
                    running: true
                }
            }
        }
    }
}
