import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Number of trajectories:" }
    IntNumField {
        bottomValue: 0
        targetValue: generalSettings.numTrajectories
        onTargetValueChanged: generalSettings.numTrajectories = targetValue
    }
    Label { text: "Population path:" }
    TextField {
        text: generalSettings.populationPath
        onEditingFinished: generalSettings.populationPath = text
    }
    Label { text: "Detection mild probability:" }
    DoubleNumField {
        topValue: 1.0
        targetValue: generalSettings.detectionMildProbability
        onTargetValueChanged: generalSettings.detectionMildProbability = targetValue
    }
    Label { text: "Stop simulation treshold:" }
    IntNumField {
        bottomValue: 0
        targetValue: generalSettings.stopSimulationThreshold
        onTargetValueChanged: generalSettings.stopSimulationThreshold = targetValue
    }
}
