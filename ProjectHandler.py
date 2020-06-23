# This Python file uses the following encoding: utf-8
from ProjectSettings import *
import logging
import json
from PyQt5.QtCore import * #QObject, QVariant, QAbstractTableModel, QModelIndex, pyqtSlot

class FunctionParametersModel(QAbstractTableModel):
    @pyqtProperty(int)
    def PropertyName(self):
        return Qt.UserRole + 1

    @pyqtProperty(int)
    def PropertyValue(self):
        return Qt.UserRole + 2

    @pyqtProperty(int)
    def PropertyType(self):
        return Qt.UserRole + 3

    @pyqtProperty(int)
    def IntegerValueProperty(self):
        return ValueTypes.IntegerValue.value

    @pyqtProperty(int)
    def DoubleValueProperty(self):
        return ValueTypes.FloatValue.value

    _data = EmptyModulationParams()

    @pyqtSlot(int, result=QVariant)
    def getPropertyType(self, row):
        return self.data(self.index(row, 1), self.PropertyType)

    def setParameters(self, newData):
        maxRowsNum = max(len(newData._properties), len(self._data._properties))
        self.layoutAboutToBeChanged.emit()
        self._data = newData
        leftTop = self.createIndex(0, 0)
        rightBottom = self.createIndex(maxRowsNum, 1)
        self.changePersistentIndex(leftTop, rightBottom)
        self.layoutChanged.emit()

    def columnCount(self, parentIndex):
        return 0 if len(self._data._properties) == 0 else 2

    def rowCount(self, parentIndex):
        return len(self._data._properties)

    def flags(self, index):
        return QtCore.Qt.ItemIsEditable | QtCore.Qt.ItemIsEnabled

    def data(self, index, role):
        if not index.isValid():
            return QVariant()
        if role == self.PropertyName:
            return QVariant(self._data._properties[index.row()])
        if role == self.PropertyValue:
            return QVariant(self._data._values[index.row()])
        if role == self.PropertyType:
            return QVariant(self._data._valueTypes[index.row()].value)
        return QVariant()

    def setData(self, index, value, role):
        if not index.isValid():
            return False
        if role != self.PropertyValue:
            return False
        assert(index.row() < len(self._data._properties))
        if self._data._valueTypes[index.row()] == ValueTypes.IntegerValue:
            self._data._values[index.row()] = int(value)
            return True
        if self._data._valueTypes[index.row()] == ValueTypes.FloatValue:
            self._data._values[index.row()] = value
            return True
        return False

    def roleNames(self):
        return {
            self.PropertyName  : QByteArray().append("propertyName"),
            self.PropertyValue : QByteArray().append("propertyValue"),
            self.PropertyType  : QByteArray().append("propertyType")
        }

class ProjectHandler(QObject):
    settings = ProjectSettings()
    modulationModel = FunctionParametersModel()

    @pyqtSlot(str)
    def saveAs(self, path):
        path = path.replace("file:///", "")
        fh = open(path, "w", encoding='utf-8')
        json.dump( self.settings.serialize(), fh, indent=4, ensure_ascii=False )
        fh.close()

    @pyqtSlot(result=QVariant)
    def getModulationFunctionTypes(self):
        return ModulationFunctions.values()

    @pyqtSlot(str)
    def loadParamsForFunction(self, funcType):
        wantedFunc = ModulationFunctions.from_value(funcType)
        if self.settings.modulation._function != wantedFunc:
            self.settings.modulation._function = wantedFunc
            self.settings.modulation._params = TanhModulationParams()
            self.modulationModel.setParameters(self.settings.modulation._params)
