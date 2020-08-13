import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.1
import Qt.labs.platform 1.1 as QtLabsPlatform

ColumnLayout {
    id: runSimulationView
    signal showLogWindow()

    FileDialog {
        id: juliaSelectDialog
        folder: shortcuts.home
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JULIA executable (*)" ]
        onAccepted: {
            applicationSettings.juliaCommand = juliaSelectDialog.fileUrl
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
            text: "Julia command:"
        }
        TextField {
            id: juliaCommandField
            text: applicationSettings.juliaCommand
            onAccepted: applicationSettings.juliaCommand = text
            onActiveFocusChanged: {
                if (!activeFocus) {
                    applicationSettings.juliaCommand = text !== "" ? text : "julia"
                }
            }
            color: applicationSettings.juliaCommandAcceptable ? "black" : "red"
            KeyNavigation.tab: outputDailyField
        }
        Button {
            text: "Select"
            onClicked: juliaSelectDialog.visible = true
        }
        Button {
            text: "Default"
            onClicked: applicationSettings.juliaCommand = "julia"
        }
        Label {
            text: "Output daily:"
        }
        TextField {
            id: outputDailyField
            text: applicationSettings.outputDaily
            onAccepted: applicationSettings.outputDaily = text
            onActiveFocusChanged: if (!activeFocus) applicationSettings.outputDaily = text
            color: applicationSettings.outputDailyAcceptable ? "black" : "red"
            KeyNavigation.tab: outputSummaryField
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
            id: outputSummaryField
            text: applicationSettings.outputSummary
            onAccepted: applicationSettings.outputSummary = text
            onActiveFocusChanged: if (!activeFocus) applicationSettings.outputSummary = text
            color: applicationSettings.outputSummaryAcceptable ? "black" : "red"
            KeyNavigation.tab: outputParamsDumpField
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
            id: outputParamsDumpField
            text: applicationSettings.outputParamsDump
            onFocusChanged: applicationSettings.outputParamsDump = text
            onAccepted: applicationSettings.outputParamsDump = text
            color: applicationSettings.outputParamsDumpAcceptable ? "black" : "red"
            KeyNavigation.tab: outputRunDumpPrefixField
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
            id: outputRunDumpPrefixField
            text: applicationSettings.outputRunDumpPrefix
            onAccepted: applicationSettings.outputRunDumpPrefix = text
            onActiveFocusChanged: if (!activeFocus) applicationSettings.outputRunDumpPrefix = text
            color: applicationSettings.outputRunDumpPrefixAcceptable ? "black" : "red"
            KeyNavigation.tab: runSimulationButton
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
            KeyNavigation.tab: juliaCommandField
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
