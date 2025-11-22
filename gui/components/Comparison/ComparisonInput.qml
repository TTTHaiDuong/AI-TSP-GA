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
                        gaParams.append({
                            "prop": "gaEliteSize",
                            "name": "Elite size",
                            "value": ComparisonInputProps.gaEliteSize,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        gaParams.append({
                            "prop": "gaTournament",
                            "name": "Tournament",
                            "value": ComparisonInputProps.gaTournament,
                            "from": 1,
                            "to": 100000,
                            "step": 1
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
                title: "ACO"

                Flow {
                    Layout.fillWidth: true
                    spacing: 20

                    ListModel {
                        id: acoParams
                    }

                    Component.onCompleted: {
                        acoParams.append({
                            "prop": "acoPopSize",
                            "name": "Population size",
                            "value": ComparisonInputProps.acoPopSize,
                            "from": 1,
                            "to": 1000,
                            "step": 1
                        });
                        acoParams.append({
                            "prop": "acoIterations",
                            "name": "Number of iterations",
                            "value": ComparisonInputProps.acoIterations,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        acoParams.append({
                            "prop": "acoAlpha",
                            "name": "Alpha",
                            "value": ComparisonInputProps.acoAlpha,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        acoParams.append({
                            "prop": "acoBeta",
                            "name": "Beta",
                            "value": ComparisonInputProps.acoBeta,
                            "from": 0,
                            "to": 50,
                            "step": 0.1
                        });
                        acoParams.append({
                            "prop": "acoRho",
                            "name": "Rho",
                            "value": ComparisonInputProps.acoRho,
                            "from": 0,
                            "to": 50,
                            "step": 0.01
                        });
                    }

                    Repeater {
                        model: acoParams
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

                Flow {
                    Layout.fillWidth: true
                    spacing: 20

                    ListModel {
                        id: saParams
                    }

                    Component.onCompleted: {
                        saParams.append({
                            "prop": "saTmax",
                            "name": "T max",
                            "value": ComparisonInputProps.saTmax,
                            "from": 1,
                            "to": 1000,
                            "step": 1
                        });
                        saParams.append({
                            "prop": "saTmin",
                            "name": "T min",
                            "value": ComparisonInputProps.saTmin,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                        saParams.append({
                            "prop": "saL",
                            "name": "L",
                            "value": ComparisonInputProps.saL,
                            "from": 1,
                            "to": 100000,
                            "step": 1
                        });
                    }

                    Repeater {
                        model: saParams
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
                id: heldKarpPanel
                title: "Held-Karp"

                Item {
                    height: 400
                    Label {
                        text: "Thuật toán Held-Karp chỉ sử dụng ma trận chi phí, không cần phải truyền tham số nào khác."
                        wrapMode: Text.WordWrap
                        width: heldKarpPanel.implicitWidth - 2 * heldKarpPanel.padding
                    }
                }
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
            for (let i = 0; i < acoParams.count; i++) {
                if (acoParams.get(i).prop === prop) {
                    acoParams.setProperty(i, "value", v);
                    return;
                }
            }
            for (let i = 0; i < saParams.count; i++) {
                if (saParams.get(i).prop === prop) {
                    saParams.setProperty(i, "value", v);
                    return;
                }
            }
        }

        onGaPopSizeChanged: onAnyUpdate("gaPopSize", ComparisonInputProps.gaPopSize)
        onGaGenerationsChanged: onAnyUpdate("gaGenerations", ComparisonInputProps.gaGenerations)
        onGaCrossoverChanged: onAnyUpdate("gaCrossover", ComparisonInputProps.gaCrossover)
        onGaMutationChanged: onAnyUpdate("gaMutation", ComparisonInputProps.gaMutation)
        onGaEliteSizeChanged: onAnyUpdate("gaEliteSize", ComparisonInputProps.gaEliteSize)
        onGaTournamentChanged: onAnyUpdate("gaTournament", ComparisonInputProps.gaTournament)

        onPsoSwarmSizeChanged: onAnyUpdate("psoSwarmSize", ComparisonInputProps.psoSwarmSize)
        onPsoIterationsChanged: onAnyUpdate("psoIterations", ComparisonInputProps.psoIterations)
        onPsoInitVelocityChanged: onAnyUpdate("psoInitVelocity", ComparisonInputProps.psoInitVelocity)
        onPsoInertiaWeightChanged: onAnyUpdate("psoInertiaWeight", ComparisonInputProps.psoInertiaWeight)
        onPsoCognitiveCoefChanged: onAnyUpdate("psoCognitiveCoef", ComparisonInputProps.psoCognitiveCoef)
        onPsoSocialCoefChanged: onAnyUpdate("psoSocialCoef", ComparisonInputProps.psoSocialCoef)
        onPsoVelocityClampingChanged: onAnyUpdate("psoVelocityClamping", ComparisonInputProps.psoVelocityClamping)

        onAcoPopSizeChanged: onAnyUpdate("acoPopSize", ComparisonInputProps.acoPopSize)
        onAcoIterationsChanged: onAnyUpdate("acoIterations", ComparisonInputProps.acoIterations)
        onAcoAlphaChanged: onAnyUpdate("acoAlpha", ComparisonInputProps.acoAlpha)
        onAcoBetaChanged: onAnyUpdate("acoBeta", ComparisonInputProps.acoBeta)
        onAcoRhoChanged: onAnyUpdate("acoRho", ComparisonInputProps.acoRho)

        onSaTmaxChanged: onAnyUpdate("saTmax", ComparisonInputProps.saTmax)
        onSaTminChanged: onAnyUpdate("saTmin", ComparisonInputProps.saTmin)
        onSaLChanged: onAnyUpdate("saL", ComparisonInputProps.saL)
    }
}
