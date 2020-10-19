import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4 as QC14

Item {
    id: modulationSettingsView

    function loadNewParams(isInitialization) {
        projectHandler.loadParamsForFunction(modulationFuncComboBox.currentText, !isInitialization)
        tableView.visible = modulationModel.rowCount() > 0
        tableView.Layout.minimumHeight = tableView.defaultRowHeight * modulationModel.rowCount()
                + tableView.defaultHeaderHeight + 1
        tableView.fillListOfEditFields()
        modulationFuncComboBox.KeyNavigation.tab = tableView.getItemToFocusAfterComboBox()
    }

    Connections {
        target: projectHandler
        function onModulationFunctionChanged() {
            let newIndex = projectHandler.getModulationFunctionTypes().indexOf(projectHandler.getActiveModulationFunction())
            if (modulationFuncComboBox.currentIndex === newIndex) {
                modulationSettingsView.loadNewParams(false)
            } else {
                modulationFuncComboBox.currentIndex = newIndex
            }
        }
    }

    ColumnLayout {
        GridLayout {
            columns: 2
            columnSpacing: 10

            Label { text: "Function type:" }
            ComboBox {
                focus: true
                id: modulationFuncComboBox
                model: projectHandler.getModulationFunctionTypes()
                currentIndex: projectHandler.getModulationFunctionTypes().indexOf(projectHandler.getActiveModulationFunction())
                KeyNavigation.tab: tableView
                property bool isInitialization: true
                onCurrentTextChanged: {
                    modulationSettingsView.loadNewParams(isInitialization)
                    isInitialization = false
                }
            }
        }

        QC14.TableView {
            id: tableView
            clip: true

            property int defaultHeaderHeight: 20
            property int defaultRowHeight: 30
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            backgroundVisible: false

            KeyNavigation.tab: modulationFuncComboBox

            function getItemToFocusAfterComboBox() {
                if (tableView.listOfEditFields.length === 0) {
                    return tableView
                }
                return tableView.listOfEditFields[0]
            }

            headerDelegate: Rectangle {
                activeFocusOnTab: false
                implicitHeight: tableView.defaultHeaderHeight
                border.color: "darkgrey"
                color: "lightgrey"
                objectName: "headerDelegate"
                Label {
                    rightPadding: 15
                    leftPadding: 15
                    horizontalAlignment: {
                        if (styleData.column === 0) {
                            return Text.AlignRight
                        }
                        else {
                            return Text.AlignLeft
                        }
                    }
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    text: styleData.value
                }
            }

            Layout.minimumWidth: 400

            rowDelegate: Item { height: tableView.defaultRowHeight }

            property variant listOfEditFields: []

            function fillListOfEditFields() {
                this.listOfEditFields = []
                this.traverseChildrenItemsLookingForEditFields(tableView)
            }

            function traverseChildrenItemsLookingForEditFields(item) {
                if (item instanceof DoubleNumField) {
                    listOfEditFields.push(item)
                }
                else if (item instanceof IntNumField) {
                    listOfEditFields.push(item)
                }

                for (let i=0; i<item.children.length; ++i) {
                    traverseChildrenItemsLookingForEditFields(item.children[i])
                }
            }

            Component.onCompleted: {
                Layout.minimumHeight = defaultRowHeight * modulationModel.rowCount() + defaultHeaderHeight + 1
                tableView.fillListOfEditFields()
                modulationFuncComboBox.KeyNavigation.tab = tableView.getItemToFocusAfterComboBox()
            }

            QC14.TableViewColumn {
                id: propertyNameColumn
                title: "Property"
                role: "propertyName"
                movable: false
                width: tableView.viewport.width * 0.4
                objectName: "propertyNameColumn"
            }

            QC14.TableViewColumn {
                id: propertyValueColumn
                title: "Value"
                role: "propertyValue"
                movable: false
                width: tableView.viewport.width - propertyNameColumn.width
                objectName: "propertyValueColumn"
            }

            model: modulationModel

            itemDelegate: Item {
                objectName: "itemDelegate"
                property int row: styleData.row
                property int column: styleData.column
                Component {
                    id: propertyNameComponent
                    Rectangle {
                        implicitWidth: propertyNameColumn.width
                        implicitHeight: tableView.defaultRowHeight
                        Label {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            rightPadding: 15
                            text: styleData.value + ":"
                        }
                    }
                }

                Component {
                    id: propertyIntegerValueComponent
                    Rectangle {
                        implicitWidth: propertyValueColumn.width
                        implicitHeight: tableView.defaultRowHeight
                        IntNumField {
                            property int row: styleData.row
                            anchors.fill: parent
                            targetValue: styleData.value
                            onTargetValueChanged: {
                                modulationModel.setData(
                                    modulationModel.index(styleData.row, styleData.column),
                                    targetValue, modulationModel.PropertyValue)
                            }
                        }
                    }
                }

                Component {
                    id: propertyPositiveDoubleValueComponent
                    Rectangle {
                        implicitWidth: propertyValueColumn.width
                        implicitHeight: tableView.defaultRowHeight
                        DoubleNumField {
                            property int row: styleData.row
                            anchors.fill: parent
                            targetValue: styleData.value
                            onTargetValueChanged: {
                                modulationModel.setData(
                                    modulationModel.index(styleData.row, styleData.column),
                                        targetValue, modulationModel.PropertyValue)
                            }
                        }
                    }
                }

                Component {
                    id: propertyInfiniteDoubleValueComponent
                    Rectangle {
                        implicitWidth: propertyValueColumn.width
                        implicitHeight: tableView.defaultRowHeight
                        DoubleNumField {
                            property int row: styleData.row
                            anchors.fill: parent
                            bottomValue: -Infinity
                            targetValue: styleData.value
                            onTargetValueChanged: {
                                modulationModel.setData(
                                    modulationModel.index(styleData.row, styleData.column),
                                        targetValue, modulationModel.PropertyValue)
                            }
                        }
                    }
                }

                Loader {
                    sourceComponent: {
                        if (styleData.column === 0) {
                            return propertyNameComponent
                        }
                        else {
                            let pt = modulationModel.getPropertyType(styleData.row)
                            if (pt === modulationModel.PositiveIntegerTypeProperty) {
                                return propertyPositiveIntegerValueComponent
                            }
                            else if (pt === modulationModel.PositiveDoubleTypeProperty) {
                                return propertyPositiveDoubleValueComponent
                            }
                            return propertyInfiniteDoubleValueComponent
                        }
                    }
                }
            }
        }
    }
}
