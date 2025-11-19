import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

ColumnLayout {
    spacing: 0

    MaterialButton {
        Layout.fillWidth: true
        implicitHeight: 40
        pressScale: false

        Label {
            text: "Comparison parameters"
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ScrollBar.vertical: ScrollBar {
            width: 12
            policy: dropAlgoParamsList.height > height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }

        ColumnLayout {
            id: dropAlgoParamsList
            width: parent.parent.width
            spacing: 0

            DropPanel {
                title: "Genetic"

                Flow {
                    Layout.fillWidth: true
                    spacing: 20

                    ListModel {
                        id: gaParams
                    }

                    Component.onCompleted: {
                        gaParams.append({
                            "prop": "gaPopSize",
                            "name": "Population size",
                            "value": ComparisonInputProps.gaPopSize,
                            "from": 1,
                            "to": 1000,
                            "step": 1
                        });
                        gaParams.append({
                            "prop": "gaGenerations",
                            "name": "Generations",
                            "value": ComparisonInputProps.gaGenerations,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        gaParams.append({
                            "prop": "gaCrossover",
                            "name": "Crossover rate",
                            "value": ComparisonInputProps.gaCrossover,
                            "from": 0,
                            "to": 1,
                            "step": 0.1
                        });
                        gaParams.append({
                            "prop": "gaMutation",
                            "name": "Mutation rate",
                            "value": ComparisonInputProps.gaMutation,
                            "from": 0,
                            "to": 1,
                            "step": 0.01
                        });
                    }

                    Repeater {
                        model: gaParams
                        delegate: ColumnLayout {
                            width: 130
                            spacing: 0

                            Label {
                                text: model.name
                            }
                            MaterialSpinBox {
                                from: model.from
                                to: model.to
                                step: model.step
                                grayedOut: value === 0
                                value: model.value
                                onValueChanged: ComparisonInputProps[model.prop] = value
                            }
                        }
                    }
                }
            }

            DropPanel {
                title: "PSO"

                Flow {
                    Layout.fillWidth: true
                    spacing: 20

                    ListModel {
                        id: psoParams
                    }

                    Component.onCompleted: {
                        psoParams.append({
                            "prop": "psoSwarmSize",
                            "name": "Swarm size",
                            "value": ComparisonInputProps.psoSwarmSize,
                            "from": 1,
                            "to": 1000,
                            "step": 1
                        });
                        psoParams.append({
                            "prop": "psoIterations",
                            "name": "Number of iterations",
                            "value": ComparisonInputProps.psoIterations,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        psoParams.append({
                            "prop": "psoInitVelocity",
                            "name": "Initial velocity",
                            "value": ComparisonInputProps.psoInitVelocity,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        psoParams.append({
                            "prop": "psoInertiaWeight",
                            "name": "Inertia weight (w)",
                            "value": ComparisonInputProps.psoInertiaWeight,
                            "from": 0,
                            "to": 50,
                            "step": 0.1
                        });
                        psoParams.append({
                            "prop": "psoCognitiveCoef",
                            "name": "Cognitive coef (c1)",
                            "value": ComparisonInputProps.psoCognitiveCoef,
                            "from": 0,
                            "to": 50,
                            "step": 0.01
                        });
                        psoParams.append({
                            "prop": "psoSocialCoef",
                            "name": "Social coef (c2)",
                            "value": ComparisonInputProps.psoSocialCoef,
                            "from": 0,
                            "to": 50,
                            "step": 0.01
                        });
                        psoParams.append({
                            "prop": "psoVelocityClamping",
                            "name": "Velocity clamping",
                            "value": ComparisonInputProps.psoVelocityClamping,
                            "from": 0,
                            "to": 50,
                            "step": 0.01
                        });
                    }

                    Repeater {
                        model: psoParams
                        delegate: ColumnLayout {
                            width: 130
                            spacing: 0

                            Label {
                                text: model.name
                            }
                            MaterialSpinBox {
                                from: model.from
                                to: model.to
                                step: model.step
                                grayedOut: value === 0
                                value: model.value
                                onValueChanged: ComparisonInputProps[model.prop] = value
                            }
                        }
                    }
                }
            }

            DropPanel {
                title: "SA"
            }

            DropPanel {
                title: "ACO"
            }

            DropPanel {
                title: "Held-Karp"
            }
        }
    }

    Connections {
        target: ComparisonInputProps

        function onAnyUpdate(prop, v) {
            for (let i = 0; i < gaParams.count; i++) {
                if (gaParams.get(i).prop === prop) {
                    gaParams.setProperty(i, "value", v);
                    return;
                }
            }
            for (let i = 0; i < psoParams.count; i++) {
                if (psoParams.get(i).prop === prop) {
                    psoParams.setProperty(i, "value", v);
                    return;
                }
            }
        }

        onGaPopSizeChanged: onAnyUpdate("gaPopSize", ComparisonInputProps.gaPopSize)
        onGaGenerationsChanged: onAnyUpdate("gaGenerations", ComparisonInputProps.gaGenerations)
        onGaCrossoverChanged: onAnyUpdate("gaCrossover", ComparisonInputProps.gaCrossover)
        onGaMutationChanged: onAnyUpdate("gaMutation", ComparisonInputProps.gaMutation)

        onPsoSwarmSizeChanged: onAnyUpdate("psoSwarmSize", ComparisonInputProps.psoSwarmSize)
        onPsoIterationsChanged: onAnyUpdate("psoIterations", ComparisonInputProps.psoIterations)
        onPsoInitVelocityChanged: onAnyUpdate("psoInitVelocity", ComparisonInputProps.psoInitVelocity)
        onPsoInertiaWeightChanged: onAnyUpdate("psoInertiaWeight", ComparisonInputProps.psoInertiaWeight)
        onPsoCognitiveCoefChanged: onAnyUpdate("psoCognitiveCoef", ComparisonInputProps.psoCognitiveCoef)
        onPsoSocialCoefChanged: onAnyUpdate("psoSocialCoef", ComparisonInputProps.psoSocialCoef)
        onPsoVelocityClampingChanged: onAnyUpdate("psoVelocityClamping", ComparisonInputProps.psoVelocityClamping)
    }
}
