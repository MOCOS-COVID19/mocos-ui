import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Number of trajectories:" }
    IntNumField {
        id: numTrajectoriesInputField
        bottomValue: 0
        targetValue: generalSettings.numTrajectories
        onTargetValueChanged: generalSettings.numTrajectories = targetValue
        KeyNavigation.tab: populationPathInputField
    }
    Label { text: "Population path:" }
    TextField {
        id: populationPathInputField
        text: generalSettings.populationPath
        onEditingFinished: generalSettings.populationPath = text
        KeyNavigation.tab: detectionMildProbabilityInputField
    }
    Label { text: "Detection mild probability:" }
    DoubleNumField {
        id: detectionMildProbabilityInputField
        topValue: 1.0
        targetValue: generalSettings.detectionMildProbability
        onTargetValueChanged: generalSettings.detectionMildProbability = targetValue
        KeyNavigation.tab: stopSimulationThresholdInputField
    }
    Label { text: "Stop simulation treshold:" }
    IntNumField {
        id: stopSimulationThresholdInputField
        bottomValue: 0
        targetValue: generalSettings.stopSimulationThreshold
        onTargetValueChanged: generalSettings.stopSimulationThreshold = targetValue
        KeyNavigation.tab: numTrajectoriesInputField
    }
}
