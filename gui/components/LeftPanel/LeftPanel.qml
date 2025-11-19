import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../CostMatrix"
import "../Comparison"
import "../Bridge"
import ".."

Item {
    id: root
    property bool openCostMatrix

    signal headerClicked

    QuickInput {
        visible: LeftRightPanelBridge.currentTabBarIndex !== 2 && !costMatrixPanel.visible
        anchors.fill: parent
    }

    CostMatrixPanel {
        id: costMatrixPanel
        anchors.fill: parent
        visible: false
    }

    ComparisonInput {
        visible: LeftRightPanelBridge.currentTabBarIndex === 2 && !costMatrixPanel.visible
        anchors.fill: parent
    }

    Connections {
        target: LeftRightPanelBridge

        function onCostMatrixOpenRequest() {
            costMatrixPanel.visible = !costMatrixPanel.visible;
        }
    }
}
