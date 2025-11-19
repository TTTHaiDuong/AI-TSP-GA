pragma Singleton
import QtQuick

QtObject {
    property int gaPopSize: 50
    property int gaGenerations: 100
    property real gaCrossover: 0.1
    property real gaMutation: 0.03

    property int psoSwarmSize: 50
    property int psoIterations: 100
    property real psoInitVelocity: 10
    property real psoInertiaWeight: 0.8
    property real psoCognitiveCoef: 0.05
    property real psoSocialCoef: 0.05
    property real psoVelocityClamping: 0.05
}
