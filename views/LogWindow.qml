import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4 as QtQC1_4
import QtQuick.Layouts 1.0

Window {
    title: "Simulation Log"
    width: 640
    height: 360

    Item {
        anchors.fill: parent
        Row {
            id: buttonsRow
            spacing: 10
            Button {
                id: runSimulationButton
                text: "RUN"
                onClicked: projectHandler.runSimulation()
                enabled: !simulationRunner.isRunning
            }
            Button {
                id: stopSimulationButton
                text: "STOP"
                onClicked: projectHandler.stopSimulation()
                enabled: simulationRunner.isRunning
            }
            Column {
                Label {
                    id: progressLabel
                    text: simulationRunner.currentState()
                }
                ProgressBar {
                    id: progressBar
                    value: simulationRunner.currentProgress()
                }
            }
        }
        QtQC1_4.TextArea {
            id: logViewer
            wrapMode: Text.WordWrap
            text: ""
            readOnly: true
            anchors.top: buttonsRow.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Connections {
        target: simulationRunner
        function onPrintSimulationMsg(msg) {
            let newText = logViewer.text + msg
            logViewer.text = newText
        }
        function onClearLog() {
            logViewer.text = ""
        }
        function onNotifyStateAndProgress(state, progress) {
            progressLabel.text = state
            progressBar.value = progress / 100
        }
    }
    Connections {
        target: projectHandler
        function onLogDebug(msg) {
            let newText = logViewer.text + msg
            logViewer.text = newText
        }
    }
}
