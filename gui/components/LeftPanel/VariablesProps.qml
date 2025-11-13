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

    signal expandedUpdate(bool v)
    signal algoIndexUpdate(int v)

    signal gaPopSizeUpdate(int v)
    signal gaGenerationsUpdate(int v)
    signal gaCrossoverUpdate(double v)
    signal gaMutationUpdate(double v)

    signal psoSwarmSizeUpdate(int v)
    signal psoIterationsUpdate(int v)
    signal psoInitVelocityUpdate(double v)
    signal psoInertiaWeightUpdate(double v)
    signal psoCognitiveCoefUpdate(double v)
    signal psoSocialCoefUpdate(double v)
    signal psoVelocityClampingUpdate(double v)

    onExpandedChanged: expandedUpdate(expanded)
    onAlgoIndexChanged: algoIndexUpdate(algoIndex)

    onGaPopSizeChanged: gaPopSizeUpdate(gaPopSize)
    onGaGenerationsChanged: gaGenerationsUpdate(gaGenerations)
    onGaCrossoverChanged: gaCrossoverUpdate(gaCrossover)
    onGaMutationChanged: gaMutationUpdate(gaMutation)

    onPsoSwarmSizeChanged: psoSwarmSizeUpdate(psoSwarmSize)
    onPsoIterationsChanged: psoIterationsUpdate(psoIterations)
    onPsoInitVelocityChanged: psoInitVelocityUpdate(psoInitVelocity)
    onPsoInertiaWeightChanged: psoInertiaWeightUpdate(psoInertiaWeight)
    onPsoCognitiveCoefChanged: psoCognitiveCoefUpdate(psoCognitiveCoef)
    onPsoSocialCoefChanged: psoSocialCoefUpdate(psoSocialCoef)
    onPsoVelocityClampingChanged: psoVelocityClampingUpdate(psoVelocityClamping)
}
