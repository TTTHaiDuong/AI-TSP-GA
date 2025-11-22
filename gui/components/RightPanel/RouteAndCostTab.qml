import QtQuick
import QtQuick.Layouts
import "../Bridge"
import "../Comparison"
import ".."

Column {
    id: root

    property bool medium: width < 900
    property var costChartValues: [[], []]

    signal editClicked

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40

        Text {
            id: title
            anchors.centerIn: parent
        }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        Item {
            Layout.fillWidth: true
        }

        // Bản đồ đường đi
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
        }

        // Biểu đồ cost
        LineChart {
            Layout.preferredWidth: !root.medium ? 480 : 0
            Layout.preferredHeight: !root.medium ? 480 : 0

            values: root.costChartValues
            labels: ["Average cost", "Best cost"]
        }

        Item {
            Layout.fillWidth: !root.medium
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

            RunAlgoPanel {
                anchors.fill: parent
                anchors.margins: 20

                onRun: {
                    const cities = CitiesInputProps.cities;
                    if (cities.length < 3)
                        return;

                    const pMatrix = costMatrixBridge.buildPrototypeMatrix(cities, AsymmetricRulesInputProps.rules || []);
                    const fMatrix = costMatrixBridge.buildFinalMatrix(pMatrix);

                    let result;
                    if (VariablesProps.algoIndex === 0) {
                        const popSize = VariablesProps.gaPopSize;
                        const crossover = VariablesProps.gaCrossover;
                        const mutation = VariablesProps.gaMutation;
                        const eliteSize = VariablesProps.gaEliteSize;
                        const tournament = VariablesProps.gaTournament;
                        const generations = VariablesProps.gaGenerations;
                        const seed = useSeed ? this.seed : -1;

                        result = optimizationBridge.runGA(fMatrix, popSize, crossover, mutation, eliteSize, tournament, generations, seed);
                        title.text = "Genetic's Optimization";
                    } else if (VariablesProps.algoIndex === 1) {
                        const swarmSize = VariablesProps.psoSwarmSize;
                        const initV = VariablesProps.psoInitVelocity;
                        const inertiaW = VariablesProps.psoInertiaWeight;
                        const cognitiveCoef = VariablesProps.psoCognitiveCoef;
                        const socialCoef = VariablesProps.psoSocialCoef;
                        const velocityClamp = VariablesProps.psoVelocityClamping;
                        const iters = VariablesProps.psoIterations;
                        const seed = useSeed ? this.seed : -1;

                        result = optimizationBridge.runPSO(fMatrix, swarmSize, initV, inertiaW, cognitiveCoef, socialCoef, velocityClamp, iters, seed);
                        title.text = "PSO's Optimization";
                    }

                    const avgCost = result.avgCostHist.map((c, i) => ({
                                x: i,
                                y: c
                            }));
                    const bestCost = result.bestCostHist.map((c, i) => ({
                                x: i,
                                y: c
                            }));

                    root.costChartValues = [avgCost, bestCost];
                    routeMap.setRoute(result.bestRoute);
                    this.bestCosts = result.bestCostHist;
                    this.time = result.time;
                    this.memory = result.memory;
                }

                onClear: {
                    routeMap.chart.lineSeries.clear();
                    root.costChartValues = [[], []];
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
