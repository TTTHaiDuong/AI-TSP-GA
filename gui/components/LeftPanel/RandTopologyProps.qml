pragma Singleton
import QtQuick

QtObject {
    property bool generateClicked

    property bool expanded: true
    property int citiesNum: 10
    property bool useSeed: true
    property int seed: 0

    signal expandedUpdate(bool v)
    signal citiesNumUpdate(int v)
    signal useSeedUpdate(bool v)
    signal seedUpdate(int v)

    onExpandedChanged: expandedUpdate(expanded)
    onCitiesNumChanged: citiesNumUpdate(citiesNum)
    onUseSeedChanged: useSeedUpdate(useSeed)
    onSeedChanged: seedUpdate(seed)

    signal generateClick
    onGenerateClickedChanged: generateClick
}
