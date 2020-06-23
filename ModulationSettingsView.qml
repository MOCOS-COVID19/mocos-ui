import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4 as QC14

Item {
    id: modulationSettingsView

    Component.onCompleted: {
        projectHandler.loadParamsForFunction(modulationFuncComboBox.currentText)
    }

    ColumnLayout {
        GridLayout {
            columns: 2
            columnSpacing: 10

            Label { text: "Function type:" }
            ComboBox {
                id: modulationFuncComboBox
                model: projectHandler.getModulationFunctionTypes()
            }
        }

        QC14.TableView {
            id: tableView
            clip: true

            property int defaultRowHeight: 30

            Layout.minimumWidth: 400
            Layout.minimumHeight: 240
            Layout.preferredWidth: modulationSettingsView.width
            Layout.preferredHeight: modulationSettingsView.height

            rowDelegate: Item { height: tableView.defaultRowHeight }

            QC14.TableViewColumn {
                id: propertyNameColumn
                title: "Property"
                role: "propertyName"
                movable: false
                width: tableView.viewport.width * 0.4
            }

            QC14.TableViewColumn {
                id: propertyValueColumn
                title: "Value"
                role: "propertyValue"
                movable: false
                width: tableView.viewport.width - propertyNameColumn.width
            }

            model: modulationModel

            itemDelegate: Item {
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
                    id: propertyDoubleValueComponent
                    Rectangle {
                        implicitWidth: propertyValueColumn.width
                        implicitHeight: tableView.defaultRowHeight
                        DoubleNumField {
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

                Loader {
                    sourceComponent: {
                        if (styleData.column == 0) {
                            return propertyNameComponent
                        }
                        else {
                            let pt = modulationModel.getPropertyType(styleData.row)
                            return pt == modulationModel.IntegerValueProperty ? propertyIntegerValueComponent : propertyDoubleValueComponent
                        }
                    }
                }
            }
        }
    }
}
