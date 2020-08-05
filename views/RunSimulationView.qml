import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.1
import Qt.labs.platform 1.1 as QtLabsPlatform

ColumnLayout {
    id: runSimulationView
    signal showLogWindow()

    FileDialog {
        id: cliSelectDialog
        folder: shortcuts.home
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JULIA scripts (*.jl)" ]
        onAccepted: {
            applicationSettings.pathToCLI = cliSelectDialog.fileUrl
        }
    }

    FileDialog {
        id: jld2FileSelectDialog
        folder: shortcuts.home
        selectExisting: false
        sidebarVisible: true
        nameFilters: [ "JULIA IO (*.jld2)" ]
    }

    FileDialog {
        id: runDumpPrefixSelectDialog
        folder: shortcuts.home
        selectExisting: false
        sidebarVisible: true
        onAccepted: {
            applicationSettings.outputRunDumpPrefix = runDumpPrefixSelectDialog.fileUrl
        }
    }

    GridLayout {
        columns: 4
        columnSpacing: 10
        Label {
            text: "CLI:"
        }
        TextField {
            text: applicationSettings.pathToCLI
            readOnly: true
        }
        Button {
            text: "Select"
            onClicked: cliSelectDialog.visible = true
        }
        Button {
            text: "Clear"
            onClicked: applicationSettings.pathToCLI = ""
        }
        Label {
            text: "Output daily:"
        }
        TextField {
            text: applicationSettings.outputDaily
            readOnly: true
        }
        Button {
            function setOutputDaily() {
                console.log(jld2FileSelectDialog.fileUrl)
                applicationSettings.outputDaily = jld2FileSelectDialog.fileUrl
                jld2FileSelectDialog.accepted.disconnect(setOutputDaily)
            }

            text: "Select"
            onClicked: {
                jld2FileSelectDialog.accepted.connect(setOutputDaily)
                jld2FileSelectDialog.visible = true
            }
        }
        Button {
            text: "Clear"
            onClicked: applicationSettings.outputDaily = ""
        }
        Label {
            text: "Output summary:"
        }
        TextField {
            text: applicationSettings.outputSummary
            readOnly: true
        }
        Button {
            function setOutputSummary() {
                console.log(jld2FileSelectDialog.fileUrl)
                applicationSettings.outputSummary = jld2FileSelectDialog.fileUrl
                jld2FileSelectDialog.accepted.disconnect(setOutputSummary)
            }

            text: "Select"
            onClicked: {
                jld2FileSelectDialog.accepted.connect(setOutputSummary)
                jld2FileSelectDialog.visible = true
            }
        }
        Button {
            text: "Clear"
            onClicked: applicationSettings.outputSummary = ""
        }
        Label {
            text: "Output params dump:"
        }
        TextField {
            text: applicationSettings.outputParamsDump
            readOnly: true
        }
        Button {
            function setOutputParamsDump() {
                console.log(jld2FileSelectDialog.fileUrl)
                applicationSettings.outputParamsDump = jld2FileSelectDialog.fileUrl
                jld2FileSelectDialog.accepted.disconnect(setOutputParamsDump)
            }
            text: "Select"
            onClicked: {
                jld2FileSelectDialog.accepted.connect(setOutputParamsDump)
                jld2FileSelectDialog.visible = true
            }
        }
        Button {
            text: "Clear"
            onClicked: applicationSettings.outputParamsDump = ""
        }
        Label {
            text: "Output run dump prefix:"
        }
        TextField {
            text: applicationSettings.outputRunDumpPrefix
            readOnly: true
        }
        Button {
            text: "Select"
            onClicked: runDumpPrefixSelectDialog.visible = true
        }
        Button {
            text: "Clear"
            onClicked: applicationSettings.outputRunDumpPrefix = ""
        }
    }
    Row {
        spacing: 10
        Button {
            id: runSimulationButton
            text: "RUN"
            onClicked: projectHandler.runSimulation()
            enabled: !simulationRunner.isRunning()
        }
        Button {
            id: stopSimulationButton
            text: "STOP"
            onClicked: projectHandler.stopSimulation()
            enabled: simulationRunner.isRunning()
        }
        Button {
            id: showLogButton
            text: "LOG"
            onClicked: runSimulationView.showLogWindow()
        }
    }
    Label {
        id: progressLabel
        text: "State: " + simulationRunner.currentState()
    }
    ProgressBar {
        id: progressBar
        value: simulationRunner.currentProgress()
    }
    Connections {
        target: simulationRunner
        onNotifyState: {
            progressLabel.text = "State: " + description
            runSimulationButton.enabled = !simulationRunner.isRunning()
            stopSimulationButton.enabled = simulationRunner.isRunning()
        }
        onNotifyProgress: {
            progressBar.value = progress
        }
    }
}
