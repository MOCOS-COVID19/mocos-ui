import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1

Window {
    id: appSettingsWindow
    title: "Settings"
    width: 640
    height: 360
    flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint | Qt.MSWindowsFixedSizeDialogHint

    Item {
        anchors.fill: parent
        anchors.margins: 5

        GridLayout {
            id: parametersLayout
            columns: 4
            columnSpacing: 10
            Layout.margins: 10

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
                onClicked: {
                    juliaSelectDialog.folder = "file:///" + projectHandler.workdir()
                    juliaSelectDialog.visible = true
                }
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
                    applicationSettings.outputDaily = jld2FileSelectDialog.fileUrl
                    jld2FileSelectDialog.accepted.disconnect(setOutputDaily)
                }

                text: "Select"
                onClicked: {
                    jld2FileSelectDialog.folder = "file:///" + projectHandler.workdir()
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
                    applicationSettings.outputSummary = jld2FileSelectDialog.fileUrl
                    jld2FileSelectDialog.accepted.disconnect(setOutputSummary)
                }

                text: "Select"
                onClicked: {
                    jld2FileSelectDialog.folder = "file:///" + projectHandler.workdir()
                    jld2FileSelectDialog.accepted.connect(setOutputSummary)
                    jld2FileSelectDialog.visible = true
                }
            }
            Button {
                text: "Clear"
                onClicked: applicationSettings.outputSummary = ""
            }
            Label {
                text: "Output params dump folder:"
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
                    applicationSettings.outputParamsDump = jld2FileSelectDialog.fileUrl
                    jld2FileSelectDialog.accepted.disconnect(setOutputParamsDump)
                }
                text: "Select"
                onClicked: {
                    jld2FileSelectDialog.folder = "file:///" + projectHandler.workdir()
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
                KeyNavigation.tab: numOfThreadsField
            }
            Button {
                text: "Select"
                onClicked: runDumpPrefixSelectDialog.visible = true
            }
            Button {
                text: "Clear"
                onClicked: applicationSettings.outputRunDumpPrefix = ""
            }
            Label {
                text: "Number of threads:"
            }
            TextField {
                id: numOfThreadsField
                text: applicationSettings.numOfThreads
                validator: IntValidator{}
                onAccepted: applicationSettings.numOfThreads = text
                onActiveFocusChanged: if (!activeFocus) applicationSettings.numOfThreads = text
                KeyNavigation.tab: juliaCommandField
            }
            Slider {
                id: numOfThreadsSlider
                value: applicationSettings.numOfThreads
                from: 1.0
                to: applicationSettings.getMaxNumOfThreads()
                stepSize: 1.0
                onMoved: applicationSettings.numOfThreads = from + position * (to-from)
                Layout.columnSpan: 2
            }
        }
        Button {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            text: "OK"
            onClicked: appSettingsWindow.visible = false
        }
    }

    FileDialog {
        id: juliaSelectDialog
        folder: "file:///" + projectHandler.workdir()
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JULIA executable (*)" ]
        onAccepted: {
            applicationSettings.juliaCommand = juliaSelectDialog.fileUrl
        }
    }

    FileDialog {
        id: jld2FileSelectDialog
        folder: "file:///" + projectHandler.workdir()
        selectExisting: false
        sidebarVisible: true
        nameFilters: [ "JULIA IO (*.jld2)" ]
    }

    FileDialog {
        id: runDumpPrefixSelectDialog
        folder: "file:///" + projectHandler.workdir()
        selectExisting: false
        sidebarVisible: true
        onAccepted: {
            applicationSettings.outputRunDumpPrefix = runDumpPrefixSelectDialog.fileUrl
        }
    }
}
