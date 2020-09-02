import QtQuick 2.5
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4 as QtQC1_4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.0

ApplicationWindow {
    id:  mainWindow
    objectName: "mainWindow"
    title: createMainWindowTitle()
    height: 500

    visible: true

    property variant contentSources: [
        "InitialConditionsView.qml",
        "GeneralSettingsView.qml",
        "SpreadingView.qml",
        "ContactTrackingSettingsView.qml",
        "TransmissionProbabilitiesView.qml",
        "ModulationSettingsView.qml",
        "PhoneTrackingSettingsView.qml" ]
    property int currentSourceId: 1

    function loadSourceId(id) {
        contentLoader.focus = true
        console.assert(id >= 0)
        console.assert(id < mainWindow.contentSources.length)
        currentSourceId = id
        contentLoader.setSource(contentSources[currentSourceId])
        toolBar.highlightButtonWithSourceId(id)
    }

    function loadNextSource() {
        ++mainWindow.currentSourceId
        if (mainWindow.currentSourceId >= mainWindow.contentSources.length) {
            mainWindow.currentSourceId = 0
        }
        loadSourceId(currentSourceId)
    }

    function createMainWindowTitle() {
        let title = projectHandler.getOpenedConfName()
        if (projectHandler.isOpenedConfModified()) {
            title += "*"
        }
        title += " - MOCOS"
        return title
    }

    function handleQuickSave() {
        if (projectHandler.isConfirationOpenedFromFile()) {
            projectHandler.quickSave()
        }
        else {
            projectSaveDialog.visible = true
        }
    }

    Shortcut {
        sequence: StandardKey.NextChild
        onActivated: loadNextSource()
    }

    Shortcut {
        id: quickSaveShortcut
        sequence: StandardKey.Save
        onActivated: handleQuickSave()
    }

    Connections {
        target: projectHandler
        onShowErrorMsg: {
            errorMessageDialog.text = msg
            errorMessageDialog.visible = true
        }
        onOpenedNewConf: {
            mainWindow.title = createMainWindowTitle()
        }
        onOpenedConfModified: {
            mainWindow.title = createMainWindowTitle()
        }
    }

    Component.onCompleted: {
        mainWindow.width = initialConditionsButton.width
                + generalSettingsButton.width
                + contactTrackingSettingsButton.width
                + transmissionSettingsButton.width
                + modulationSettingsButton.width
                + phoneTrackingSettingsButton.width
                + spreadingSettingsButton.width
                + 50;
        recentFilesMenu.createMenuItems(applicationSettings.recentFiles)
    }

    FileDialog {
        id: projectSaveDialog
        folder: shortcuts.home
        selectExisting: false
        sidebarVisible: true
        nameFilters: [ "JSON files (*.json)" ]
        onAccepted: {
            projectHandler.saveAs(projectSaveDialog.fileUrl)
        }
    }

    FileDialog {
        id: projectOpenDialog
        folder: shortcuts.home
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JSON files (*.json)" ]
        onAccepted: {
            projectHandler.open(projectOpenDialog.fileUrl)
        }
    }

    MessageDialog {
        id: errorMessageDialog
        title: "Error"
        icon: StandardIcon.Critical
        onAccepted: {
            visible = false
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "&File"
            id: fileMenu
            Menu {
                id: recentFilesMenu
                title: "&Recent Files"
                enabled: count > 0
                width: {
                    var result = 0;
                    var padding = 0;
                    for (var i = 0; i < count; ++i) {
                        var item = itemAt(i);
                        result = Math.max(item.contentItem.implicitWidth, result);
                        padding = Math.max(item.padding, padding);
                    }
                    return result + padding * 2;
                }

                function clear() {
                    while (count !== 0) {
                        takeItem(0)
                    }
                    recentFilesMenu.enabled = false
                }

                function createMenuItems(paths) {
                    for (let i=0; i<paths.length; ++i) {
                        let item = Qt.createQmlObject(
                            "import QtQuick.Controls 2.4\n"
                            + "MenuItem {\n"
                            + "text: \"" + paths[i] + "\"\n"
                            + "onTriggered: { projectHandler.open( \"" + paths[i] + "\" ); fileMenu.close() }\n"
                            + "}",
                            recentFilesMenu)
                        addItem(item)
                    }
                    recentFilesMenu.enabled = count > 0
                }
            }
            Action {
                text: "&Open..."
                onTriggered: projectOpenDialog.visible = true
                shortcut: StandardKey.Open
            }
            Action {
                text: "Save &As..."
                onTriggered: projectSaveDialog.visible = true
                shortcut: StandardKey.SaveAs
            }
            Action {
                text: "&Save"
                onTriggered: mainWindow.handleQuickSave()
                shortcut: StandardKey.Save
            }
            Action {
                text: "&Close"
                onTriggered: mainWindow.close()
                shortcut: StandardKey.Close
            }
        }
        Menu {
            title: "&Simulation"
            Action {
                text: "S&ettings"
                onTriggered: { applicationSettingsWindow.visible = true }
            }
            Action {
                text: "&Run"
                onTriggered: projectHandler.runSimulation()
                shortcut: "Ctrl+R"
                enabled: !simulationRunner.isRunning
            }
            Action {
                text: "S&top"
                onTriggered: projectHandler.stopSimulation()
                enabled: simulationRunner.isRunning
            }
            Action {
                text: "&Log"
                onTriggered: logWindow.visible = true
                shortcut: "Ctrl+L"
            }
        }
    }

    footer: Label {
        id: statusBar
        Connections {
            target: simulationRunner
            onNotifyStateAndProgress: {
                let status = state
                if (progress >= 0) {
                    status += " " + progress + "%"
                }
                statusBar.text = status
            }
        }
    }

    header: ToolBar {
        RowLayout {
            id: toolBar
            function highlightButtonWithSourceId(id) {
                for (let i=0; i<toolBar.children.length; ++i) {
                    if (toolBar.children[i] instanceof ToolButton) {
                        toolBar.children[i].highlighted = toolBar.children[i].sourceId === id
                    }
                }
            }

            ToolButton {
                id: initialConditionsButton
                property int sourceId: 0
                activeFocusOnTab : false
                text: "Initial Conditions"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: generalSettingsButton
                property int sourceId: 1
                activeFocusOnTab : false
                text: "General"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: spreadingSettingsButton
                property int sourceId: 2
                activeFocusOnTab : false
                text: "Spreading"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: contactTrackingSettingsButton
                property int sourceId: 3
                activeFocusOnTab : false
                text: "Contact Tracking"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: transmissionSettingsButton
                property int sourceId: 4
                activeFocusOnTab : false
                text: "Transmission"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: modulationSettingsButton
                property int sourceId: 5
                activeFocusOnTab : false
                text: "Modulation"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: phoneTrackingSettingsButton
                property int sourceId: 6
                activeFocusOnTab : false
                text: "Phone Tracking"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
        }
    }

    property var logWindow: {
        var component = Qt.createComponent("LogWindow.qml")
        if (component.status === Component.Ready) {
            return component.createObject(mainWindow)
        }
        console.assert(false)
    }

    property var applicationSettingsWindow: {
        var component = Qt.createComponent("ApplicationSettingsWindow.qml")
        if (component.status === Component.Ready) {
            return component.createObject(mainWindow)
        }
        console.assert(false)
    }

    Item {
        anchors.fill: parent

        Control {
            padding: 10
            anchors.left: parent.left
            anchors.right: parent.right

            contentItem: Loader {
                id: contentLoader
                focus: true
                Component.onCompleted: {
                    mainWindow.loadSourceId(generalSettingsButton.sourceId)
                }
            }

            Connections {
                ignoreUnknownSignals: true
                target: contentLoader.item
                onShowLogWindow: {
                    logWindow.visible = true
                }
            }

            Connections {
                target: applicationSettings
                onRecentFilesChanged: {
                    recentFilesMenu.clear()
                    recentFilesMenu.createMenuItems(applicationSettings.recentFiles)
                }
            }
        }
    }
}
