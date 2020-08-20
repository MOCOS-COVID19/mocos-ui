import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.0

GridLayout {
    columns: 2
    columnSpacing: 10

    FileDialog {
        id: populationFileSelectDialog
        folder: projectHandler.workdir()
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JLD2 files (*.jld2)" ]
        onAccepted: {
            projectHandler.setPopulationFilePath(populationFileSelectDialog.fileUrl)
        }
    }

    Label { text: "Number of trajectories:" }
    IntNumField {
        id: numTrajectoriesInputField
        focus: true
        bottomValue: 0
        targetValue: generalSettings.numTrajectories
        onAfterEditingFinished: generalSettings.numTrajectories = targetValue
        KeyNavigation.tab: populationPathInputField
    }
    Label { text: "Population path:" }
    Row {
        TextField {
            id: populationPathInputField
            text: generalSettings.populationPath
            onEditingFinished: generalSettings.populationPath = text
            KeyNavigation.tab: detectionMildProbabilityInputField
        }
        Button {
            text: "Select"
            onClicked: populationFileSelectDialog.visible = true
        }
    }
    Label { text: "Detection mild probability:" }
    DoubleNumField {
        id: detectionMildProbabilityInputField
        topValue: 1.0
        targetValue: generalSettings.detectionMildProbability
        onAfterEditingFinished: generalSettings.detectionMildProbability = targetValue
        KeyNavigation.tab: stopSimulationThresholdInputField
    }
    Label { text: "Stop simulation treshold:" }
    IntNumField {
        id: stopSimulationThresholdInputField
        bottomValue: 0
        targetValue: generalSettings.stopSimulationThreshold
        onAfterEditingFinished: generalSettings.stopSimulationThreshold = targetValue
        KeyNavigation.tab: numTrajectoriesInputField
    }

    Connections {
        target: generalSettings
        onNumTrajectoriesChanged: {
            numTrajectoriesInputField.text = generalSettings.numTrajectories
        }
        onDetectionMildProbabilityChanged: {
            detectionMildProbabilityInputField.text = generalSettings.detectionMildProbability
        }
        onStopSimulationThresholdChanged: {
            stopSimulationThresholdInputField.text = generalSettings.stopSimulationThreshold
        }
    }
}
