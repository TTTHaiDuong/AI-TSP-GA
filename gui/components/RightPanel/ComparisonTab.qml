import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../Comparison"
import ".."

ColumnLayout {
    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {
            implicitWidth: 40
            Layout.fillHeight: true

            MaterialButton {
                anchors.centerIn: parent
                width: 40
                height: 40
                bgColor: "transparent"
                radius: 8

                Label {
                    anchors.centerIn: parent
                    text: "◀"
                    font.pixelSize: 30
                    color: Theme.unFocus
                }

                onClicked: view.currentIndex = (view.currentIndex - 1 + view.count) % view.count
            }
        }

        SwipeView {
            id: view
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Page {
                Rectangle {
                    anchors.fill: parent

                    PassAlgoList {
                        anchors.fill: parent
                        anchors.margins: 10
                    }
                }
            }

            Page {
                Rectangle {
                    anchors.fill: parent

                    LineChart {
                        title: "Cost Convergence"
                        anchors.fill: parent
                    }
                }
            }

            Page {
                Rectangle {
                    anchors.fill: parent

                    BarChart {
                        title: "Best Cost & Cost Function Call"
                        features: ["Cost", "Cost function call (times)"]
                        anchors.fill: parent
                    }
                }
            }

            Page {
                Rectangle {
                    anchors.fill: parent

                    BarChart {
                        id: timeAndMemoryChart
                        title: "Execution Time & Memory Usage"
                        features: ["Time (ms)", "Memory (KB)"]
                        anchors.fill: parent
                    }
                }
            }
        }

        Item {
            implicitWidth: 40
            Layout.fillHeight: true

            MaterialButton {
                anchors.centerIn: parent
                width: 40
                height: 40
                bgColor: "transparent"
                radius: 8

                Label {
                    anchors.centerIn: parent
                    text: "▶"
                    font.pixelSize: 30
                    color: Theme.unFocus
                }

                onClicked: view.currentIndex = (view.currentIndex + 1) % view.count
            }
        }
    }

    // Indicator của swipeview
    Item {
        Layout.fillWidth: true
        implicitHeight: 20

        PageIndicator {
            anchors.centerIn: parent
            count: view.count
            currentIndex: view.currentIndex
        }
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: 160

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 40
                rightMargin: 40
                topMargin: 10
                bottomMargin: 10
            }
            spacing: 50

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                RunButton {
                    anchors.centerIn: parent

                    onRun: {
                        const pMatrix = costMatrixBridge.buildPrototypeMatrix(CitiesInputProps.cities || [], AsymmetricRulesInputProps.rules || []);
                        const fMatrix = costMatrixBridge.buildFinalMatrix(pMatrix);

                        const algo = ["Genetic", "ACO", "SA", "Held-Karp"];
                        const ga = optimizationBridge.runGA(fMatrix, ComparisonInputProps.gaPopSize, ComparisonInputProps.gaCrossover, ComparisonInputProps.gaMutation, ComparisonInputProps.gaEliteSize, ComparisonInputProps.gaTournament, ComparisonInputProps.gaGenerations, -1);
                        const pso = optimizationBridge.runPSO(fMatrix, ComparisonInputProps.psoSwarmSize, ComparisonInputProps.psoInitVelocity, ComparisonInputProps.psoInertiaWeight, ComparisonInputProps.psoCognitiveCoef, ComparisonInputProps.psoSocialCoef, ComparisonInputProps.psoVelocityClamping, ComparisonInputProps.psoIterations, -1);
                        const aco = optimizationBridge.runACO(fMatrix, ComparisonInputProps.acoPopSize, ComparisonInputProps.acoIterations, ComparisonInputProps.acoAlpha, ComparisonInputProps.acoBeta, ComparisonInputProps.acoRho);
                        const sa = optimizationBridge.runSA(fMatrix, ComparisonInputProps.saTmax, ComparisonInputProps.saTmin, ComparisonInputProps.saL);
                        const heldKarp = optimizationBridge.runHeldKarp(fMatrix);

                        const timeOfAlgos = [ga.time, pso.time, aco.time, sa.time, heldKarp.time];
                        const memoryOfAlgos = [ga.memory, pso.memory, aco.memory, sa.memory, heldKarp.memory];

                        timeAndMemoryChart.values = [timeOfAlgos, memoryOfAlgos];
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 2

                Flow {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 20
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 30

                    ColumnLayout {
                        width: 150
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 16
                            z: 1

                            CheckBox {
                                id: timeLimit
                                text: "Time limit (s)"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                z: 10
                            }
                        }
                        MaterialSpinBox {
                            from: 0
                            to: 9999
                            enabled: timeLimit.checked
                            grayedOut: !enabled
                        }
                    }

                    ColumnLayout {
                        implicitWidth: 150
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 16
                            z: 1

                            CheckBox {
                                id: memoryLimit
                                text: "Memory limit (KB)"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                z: 10
                            }
                        }
                        MaterialSpinBox {
                            id: seedInput
                            from: 0
                            to: 9999
                            enabled: memoryLimit.checked
                            grayedOut: !enabled
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 2
            }
        }
    }

    Connections {
        target: optimizationBridge
    }
}
