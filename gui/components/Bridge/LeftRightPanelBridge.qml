pragma Singleton
import QtQuick

QtObject {
    property int currentTabBarIndex
    property var costMatrix

    signal costMatrixOpenRequest
}
