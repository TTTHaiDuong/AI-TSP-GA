import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

DropPanel {
    id: root
    title: "Variables"
    expanded: VariablesProps.expanded
    onExpandedChanged: VariablesProps.expanded = expanded

    ColumnLayout {
        spacing: 30

        Item {
            implicitHeight: description.implicitHeight
            Label {
                id: description
                text: "Điều chỉnh các tham số thuật toán."
                wrapMode: Text.WordWrap
                color: "#555555"
                width: root.implicitWidth - 2 * root.padding
            }
        }

        ColumnLayout {
            spacing: 0

            Label {
                text: "Algorithm"
            }

            MaterialComboBox {
                id: algoSelect
                model: ["Genetic", "PSO"]
                currentIndex: VariablesProps.algoIndex
                onCurrentIndexChanged: VariablesProps.algoIndex = currentIndex
            }
        }

        // Chế độ nhập tham số GA
        Flow {
            visible: algoSelect.currentText === "Genetic"
            Layout.fillWidth: true
            spacing: 40

            ListModel {
                id: gaParams
            }

            Component.onCompleted: {
                gaParams.append({
                    "prop": "gaPopSize",
                    "name": "Population size",
                    "value": VariablesProps.gaPopSize,
                    "from": 1,
                    "to": 1000,
                    "step": 1
                });
                gaParams.append({
                    "prop": "gaGenerations",
                    "name": "Generations",
                    "value": VariablesProps.gaGenerations,
                    "from": 1,
                    "to": 100000,
                    "step": 1
                });
                gaParams.append({
                    "prop": "gaCrossover",
                    "name": "Crossover rate",
                    "value": VariablesProps.gaCrossover,
                    "from": 0,
                    "to": 1,
                    "step": 0.1
                });
                gaParams.append({
                    "prop": "gaMutation",
                    "name": "Mutation rate",
                    "value": VariablesProps.gaMutation,
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
                delegate: Column {
                    width: 100

                    Label {
                        text: model.name
                    }
                    MaterialSpinBox {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        from: model.from
                        to: model.to
                        step: model.step
                        grayedOut: value === 0
                        value: model.value
                        onValueChanged: VariablesProps[model.prop] = value
                    }
                }
            }

            Column {
                width: 100

                CheckBox {
                    id: twoOptCheck
                    text: "2-opt max iterations"
                    Material.accent: Theme.onFocus
                    padding: 0
                    verticalPadding: 0
                    z: 10
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: -40
                    height: 16
                    checked: VariablesProps.gaTwoOptCheck
                    onCheckedChanged: VariablesProps.gaTwoOptCheck = checked
                }
                MaterialSpinBox {
                    id: twoOptMaxIterSpin
                    from: 1
                    to: 10
                    enabled: twoOptCheck.checked
                    grayedOut: !enabled
                    anchors.left: parent.left
                    anchors.right: parent.right
                    value: VariablesProps.gaTwoOptMaxIter
                    onValueChanged: VariablesProps.gaTwoOptMaxIter = value
                }
            }
        }

        // Chế độ nhập các tham số PSO
        Flow {
            visible: algoSelect.currentText === "PSO"
            Layout.fillWidth: true
            spacing: 40

            ListModel {
                id: psoParams
            }

            Component.onCompleted: {
                psoParams.append({
                    "prop": "psoSwarmSize",
                    "name": "Swarm size",
                    "value": VariablesProps.psoSwarmSize,
                    "from": 1,
                    "to": 1000,
                    "step": 1
                });
                psoParams.append({
                    "prop": "psoIterations",
                    "name": "Number of iterations",
                    "value": VariablesProps.psoIterations,
                    "from": 1,
                    "to": 100000,
                    "step": 1
                });
                psoParams.append({
                    "prop": "psoInitVelocity",
                    "name": "Initial velocity",
                    "value": VariablesProps.psoInitVelocity,
                    "from": 1,
                    "to": 100000,
                    "step": 1
                });
                psoParams.append({
                    "prop": "psoInertiaWeight",
                    "name": "Inertia weight (w)",
                    "value": VariablesProps.psoInertiaWeight,
                    "from": 0,
                    "to": 50,
                    "step": 0.1
                });
                psoParams.append({
                    "prop": "psoCognitiveCoef",
                    "name": "Cognitive coef (c1)",
                    "value": VariablesProps.psoCognitiveCoef,
                    "from": 0,
                    "to": 50,
                    "step": 0.01
                });
                psoParams.append({
                    "prop": "psoSocialCoef",
                    "name": "Social coef (c2)",
                    "value": VariablesProps.psoSocialCoef,
                    "from": 0,
                    "to": 50,
                    "step": 0.01
                });
                psoParams.append({
                    "prop": "psoVelocityClamping",
                    "name": "Velocity clamping",
                    "value": VariablesProps.psoVelocityClamping,
                    "from": 0,
                    "to": 50,
                    "step": 0.01
                });
            }

            Repeater {
                model: psoParams
                delegate: Column {
                    width: 100

                    Label {
                        text: model.name
                    }
                    MaterialSpinBox {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        from: model.from
                        to: model.to
                        step: model.step
                        grayedOut: value === 0
                        value: model.value
                        onValueChanged: VariablesProps[model.prop] = value
                    }
                }
            }
        }

        Connections {
            target: VariablesProps

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

            onExpandedChanged: root.expanded = VariablesProps.expanded
            onAlgoIndexChanged: algoSelect.currentIndex = VariablesProps.algoIndex

            onGaPopSizeChanged: onAnyUpdate("gaPopSize", VariablesProps.gaPopSize)
            onGaGenerationsChanged: onAnyUpdate("gaGenerations", VariablesProps.gaGenerations)
            onGaCrossoverChanged: onAnyUpdate("gaCrossover", VariablesProps.gaCrossover)
            onGaMutationChanged: onAnyUpdate("gaMutation", VariablesProps.gaMutation)
            onGaEliteSizeChanged: onAnyUpdate("gaEliteSize", VariablesProps.gaEliteSize)
            onGaTournamentChanged: onAnyUpdate("gaTournament", VariablesProps.gaTournament)
            onGaTwoOptMaxIterChanged: twoOptMaxIterSpin.value = VariablesProps.gaTwoOptMaxIter
            onGaTwoOptCheckChanged: twoOptCheck.checked = VariablesProps.gaTwoOptCheck

            onPsoSwarmSizeChanged: onAnyUpdate("psoSwarmSize", VariablesProps.psoSwarmSize)
            onPsoIterationsChanged: onAnyUpdate("psoIterations", VariablesProps.psoIterations)
            onPsoInitVelocityChanged: onAnyUpdate("psoInitVelocity", VariablesProps.psoInitVelocity)
            onPsoInertiaWeightChanged: onAnyUpdate("psoInertiaWeight", VariablesProps.psoInertiaWeight)
            onPsoCognitiveCoefChanged: onAnyUpdate("psoCognitiveCoef", VariablesProps.psoCognitiveCoef)
            onPsoSocialCoefChanged: onAnyUpdate("psoSocialCoef", VariablesProps.psoSocialCoef)
            onPsoVelocityClampingChanged: onAnyUpdate("psoVelocityClamping", VariablesProps.psoVelocityClamping)
        }
    }
}
