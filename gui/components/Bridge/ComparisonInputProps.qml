pragma Singleton
import QtQuick

QtObject {
    property int gaPopSize: 50
    property int gaGenerations: 100
    property real gaCrossover: 0.1
    property real gaMutation: 0.03
    property int gaEliteSize: 1
    property int gaTournament: 3

    property int psoSwarmSize: 50
    property int psoIterations: 100
    property real psoInitVelocity: 10
    property real psoInertiaWeight: 0.8
    property real psoCognitiveCoef: 0.05
    property real psoSocialCoef: 0.05
    property real psoVelocityClamping: 0.05

    property int acoPopSize: 100
    property int acoIterations: 100
    property real acoAlpha: 1
    property real acoBeta: 2
    property real acoRho: 0.5

    property int saTmax: 100
    property real saTmin: 0.9
    property int saL: 100
}
