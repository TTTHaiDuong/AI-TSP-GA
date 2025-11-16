pragma Singleton
import QtQuick

QtObject {
    property bool expanded: true
    property int algoIndex: 0

    property int gaPopSize: 50
    property int gaGenerations: 100
    property double gaCrossover: 0.1
    property double gaMutation: 0.03

    property int psoSwarmSize: 50
    property int psoIterations: 100
    property double psoInitVelocity: 10
    property double psoInertiaWeight: 0.8
    property double psoCognitiveCoef: 0.05
    property double psoSocialCoef: 0.05
    property double psoVelocityClamping: 0.05
}
