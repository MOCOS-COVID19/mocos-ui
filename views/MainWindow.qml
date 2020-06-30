import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id:  mainWindow
    objectName: "mainWindow"
    title: "MOCOS"
    height: 500

    visible: true

    Component.onCompleted: {
        mainWindow.width = initialConditionsButton.width + generalSettingsButtons.width +
                contactTrackingSettingsButton.width + transmissionSettingsButton.width +
                modulationSettingsButton.width + phoneTrackingSettingsButton.width + 50;
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
        id: populationFileOpenDialog
        folder: shortcuts.home
        selectExisting: true
        sidebarVisible: true
        nameFilters: [ "JLD2 files (*.jld2)" ]
        onAccepted: {
            generalSettings.populationPath = populationFileOpenDialog.fileUrl
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { text: "Load &population file"; onTriggered: populationFileOpenDialog.visible = true }
            MenuItem { text: "&Save As..."; onTriggered: projectSaveDialog.visible = true }
            MenuItem { text: "&Close"; onTriggered: mainWindow.close() }
        }
    }

    header: ToolBar {
        RowLayout {
            id: toolBar
            function highlightSelectedSection(sender) {
                for (let i=0; i<toolBar.children.length; ++i) {
                    if (toolBar.children[i] instanceof ToolButton) {
                        toolBar.children[i].highlighted = false
                    }
                }
                sender.highlighted = true
            }

            ToolButton {
                id: initialConditionsButton
                text: "Initial Conditions"
                onClicked: {
                    contentLoader.setSource( "InitialConditionsView.qml" )
                    toolBar.highlightSelectedSection(initialConditionsButton)
                }
            }
            ToolButton {
                id: generalSettingsButtons
                text: "General"
                onClicked: {
                    contentLoader.setSource( "GeneralSettingsView.qml" )
                    toolBar.highlightSelectedSection(generalSettingsButtons)
                }
            }
            ToolButton {
                id: contactTrackingSettingsButton
                text: "Contact Tracking"
                onClicked: {
                    contentLoader.setSource( "ContactTrackingSettingsView.qml" )
                    toolBar.highlightSelectedSection(contactTrackingSettingsButton)
                }
            }
            ToolButton {
                id: transmissionSettingsButton
                text: "Transmission"
                onClicked: {
                    contentLoader.setSource( "TransmissionProbabilitiesView.qml" )
                    toolBar.highlightSelectedSection(transmissionSettingsButton)
                }
            }
            ToolButton {
                id: modulationSettingsButton
                text: "Modulation"
                onClicked: {
                    contentLoader.setSource( "ModulationSettingsView.qml" )
                    toolBar.highlightSelectedSection(modulationSettingsButton)
                }
            }
            ToolButton {
                id: phoneTrackingSettingsButton
                text: "Phone Tracking"
                onClicked: {
                    contentLoader.setSource( "PhoneTrackingSettingsView.qml" )
                    toolBar.highlightSelectedSection(phoneTrackingSettingsButton)
                }
            }
        }
    }

    Item {
        Control {
            padding: 10
            contentItem: Loader {
                id: contentLoader

                Component.onCompleted: {
                    contentLoader.setSource( "GeneralSettingsView.qml" )
                    generalSettingsButtons.highlighted = true
                }
            }
        }
    }
}
