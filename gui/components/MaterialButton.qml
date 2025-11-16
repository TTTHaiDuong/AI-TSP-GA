import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

Button {
    id: root
    implicitHeight: 40
    topInset: 0
    bottomInset: 0

    property color bgColor: "#eaeaea"
    property int radius: 0
    property bool pressScale: true

    background: Rectangle {
        anchors.fill: parent
        color: root.bgColor
        radius: root.radius

        Ripple {
            clip: true
            clipRadius: parent.radius
            width: parent.width
            height: parent.height
            pressed: root.pressed
            anchor: root
            active: enabled && (root.down || root.visualFocus || root.hovered)
            color: root.flat && root.highlighted ? root.Material.highlightedRippleColor : root.Material.rippleColor
        }
    }

    // Hiệu ứng nhún nhẹ khi nhấp chuột
    scale: 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    onPressedChanged: {
        if (pressed && pressScale)
            root.scale = 0.90;
        else
            root.scale = 1.0;
    }
}
