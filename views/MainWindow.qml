import QtQuick 2.5
import QtQuick.Controls 2.4
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
        "ContactTrackingSettingsView.qml",
        "TransmissionProbabilitiesView.qml",
        "ModulationSettingsView.qml",
        "PhoneTrackingSettingsView.qml",
        "RunSimulationView.qml" ]
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
        mainWindow.width = initialConditionsButton.width + generalSettingsButton.width +
                contactTrackingSettingsButton.width + transmissionSettingsButton.width +
                modulationSettingsButton.width + phoneTrackingSettingsButton.width +
                runSimulationSettingsButton.width + 50;
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
            MenuItem { text: "&Open..."; onTriggered: projectOpenDialog.visible = true }
            MenuItem { text: "Save &As..."; onTriggered: projectSaveDialog.visible = true }
            MenuItem { text: "&Save"; onTriggered: mainWindow.handleQuickSave() }
            MenuItem { text: "&Close"; onTriggered: mainWindow.close() }
        }
    }

    header: ToolBar {
        RowLayout {
            id: toolBar
            function highlightButtonWithSourceId(id) {
                for (let i=0; i<toolBar.children.length; ++i) {
                    if (toolBar.children[i] instanceof ToolButton) {
                        toolBar.children[i].highlighted = toolBar.children[i].sourceId == id
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
                id: contactTrackingSettingsButton
                property int sourceId: 2
                activeFocusOnTab : false
                text: "Contact Tracking"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: transmissionSettingsButton
                property int sourceId: 3
                activeFocusOnTab : false
                text: "Transmission"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: modulationSettingsButton
                property int sourceId: 4
                activeFocusOnTab : false
                text: "Modulation"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: phoneTrackingSettingsButton
                property int sourceId: 5
                activeFocusOnTab : false
                text: "Phone Tracking"
                onClicked: {
                    mainWindow.loadSourceId(sourceId)
                }
            }
            ToolButton {
                id: runSimulationSettingsButton
                property int sourceId: 6
                activeFocusOnTab : false
                text: "Run"
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
        }
    }
}
