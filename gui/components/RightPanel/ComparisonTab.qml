import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "../Comparison"
import ".."

Column {
    id: root
    signal editClicked

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 500

        Item {
            Layout.fillHeight: true
            implicitWidth: 40

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
                    anchors.topMargin: 40

                    RowLayout {
                        anchors.fill: parent

                        Item {
                            Layout.preferredWidth: 480
                            Layout.preferredHeight: 480

                            MaterialButton {
                                anchors.top: parent.top
                                anchors.topMargin: -30
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                width: 26
                                height: 26
                                bgColor: "transparent"
                                radius: 8

                                Image {
                                    source: "../../assets/edit.svg"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.fill: parent
                                    anchors.margins: 2
                                }

                                onClicked: root.editClicked()
                            }

                            RouteMap {
                                id: routeMap
                                anchors.fill: parent
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            PassAlgoList {
                                id: passAlgoList
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.right: parent.right
                                anchors.rightMargin: 15
                                anchors.verticalCenter: parent.verticalCenter

                                property var bestRoutes

                                function showRoute() {
                                    if (bestRoutes && bestRoutes[currentIndex])
                                        routeMap.setRoute(bestRoutes[currentIndex]);
                                }

                                onBestRoutesChanged: showRoute()
                                onCurrentIndexChanged: showRoute()
                            }
                        }
                    }
                }
            }

            // Page {
            //     Rectangle {
            //         anchors.fill: parent

            //         LineChart {
            //             title: "Cost Convergence"
            //             anchors.fill: parent
            //         }
            //     }
            // }

            Page {
                Rectangle {
                    anchors.fill: parent

                    BarChart {
                        id: bestCostNFuncCallChart
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
        anchors.left: parent.left
        anchors.right: parent.right
        height: 20

        PageIndicator {
            anchors.centerIn: parent
            count: view.count
            currentIndex: view.currentIndex
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 180

        Rectangle {
            border.width: 1
            border.color: Theme.unFocus
            anchors.fill: parent
            anchors.margins: 20
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 4

                    RunButton {
                        anchors.centerIn: parent

                        onRun: {
                            const cities = CitiesInputProps.cities;
                            if (cities.length < 3)
                                return;

                            const pMatrix = costMatrixBridge.buildPrototypeMatrix(cities, AsymmetricRulesInputProps.rules || []);
                            const fMatrix = costMatrixBridge.buildFinalMatrix(pMatrix);

                            const algo = ["Genetic", "PSO", "ACO", "SA", "Held-Karp"];
                            const ga = optimizationBridge.runGA(fMatrix, ComparisonInputProps.gaPopSize, ComparisonInputProps.gaCrossover, ComparisonInputProps.gaMutation, ComparisonInputProps.gaEliteSize, ComparisonInputProps.gaTournament, ComparisonInputProps.gaGenerations, -1);
                            const pso = optimizationBridge.runPSO(fMatrix, ComparisonInputProps.psoSwarmSize, ComparisonInputProps.psoInitVelocity, ComparisonInputProps.psoInertiaWeight, ComparisonInputProps.psoCognitiveCoef, ComparisonInputProps.psoSocialCoef, ComparisonInputProps.psoVelocityClamping, ComparisonInputProps.psoIterations, -1);
                            const aco = optimizationBridge.runACO(fMatrix, ComparisonInputProps.acoPopSize, ComparisonInputProps.acoIterations, ComparisonInputProps.acoAlpha, ComparisonInputProps.acoBeta, ComparisonInputProps.acoRho);
                            const sa = optimizationBridge.runSA(fMatrix, ComparisonInputProps.saTmax, ComparisonInputProps.saTmin, ComparisonInputProps.saL);
                            const heldKarp = optimizationBridge.runHeldKarp(fMatrix);

                            const bestCosts = [ga.bestCost, pso.bestCost, aco.bestCost, sa.bestCost, heldKarp.bestCost];
                            const bestCostsFixed = bestCosts.map(v => v.toFixed(3));
                            const costFuncCalls = [ga.costFuncCall, pso.costFuncCall, aco.costFuncCall, sa.costFuncCall, heldKarp.costFuncCall];
                            const timeOfAlgos = [ga.time, pso.time, aco.time, sa.time, heldKarp.time].map(v => v.toFixed(4));
                            const memoryOfAlgos = [ga.memory, pso.memory, aco.memory, sa.memory, heldKarp.memory];

                            bestCostNFuncCallChart.values = [bestCostsFixed, costFuncCalls];
                            timeAndMemoryChart.values = [timeOfAlgos, memoryOfAlgos];
                            passAlgoList.bestRoutes = [ga.bestRoute, pso.bestRoute, aco.bestRoute, sa.bestRoute, heldKarp.bestRoute];
                            passAlgoList.col1 = bestCostsFixed;
                            passAlgoList.col2 = bestCosts.map(v => (Math.abs(v - heldKarp.bestCost) / heldKarp.bestCost).toFixed(2));
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 2

                    MaterialButton {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 32
                        height: 32
                        bgColor: "transparent"
                        radius: 8

                        Image {
                            source: "../../assets/clear.svg"
                            fillMode: Image.PreserveAspectFit
                            anchors.fill: parent
                            anchors.margins: 4
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 6
                    Layout.preferredHeight: 8

                    Flow {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 20

                        Column {
                            width: 100

                            CheckBox {
                                id: timeLimit
                                text: "Time limit (s)"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                height: 16
                                z: 10
                            }

                            MaterialSpinBox {
                                from: 0
                                to: 9999
                                enabled: timeLimit.checked
                                grayedOut: !enabled
                            }
                        }

                        Column {
                            width: 100

                            CheckBox {
                                id: memoryLimit
                                text: "Memory limit (KB)"
                                Material.accent: Theme.onFocus
                                padding: 0
                                verticalPadding: 0
                                height: 16
                                z: 10
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
            }
        }
    }

    Connections {
        target: optimizationBridge
    }

    Connections {
        target: CitiesInputProps

        function onCitiesChanged() {
            routeMap.setCities(CitiesInputProps.cities);
        }
    }
}
