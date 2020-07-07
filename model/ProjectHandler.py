# This Python file uses the following encoding: utf-8
from model.ProjectSettings import *
import logging
import json
from PyQt5.QtCore import * #QObject, QVariant, QAbstractTableModel, QModelIndex, pyqtSlot
import sys

class FunctionParametersModel(QAbstractTableModel):

    dummySignalToRemoveQmlWarning = pyqtSignal(int)

    @pyqtProperty(int)
    def PropertyName(self, notify=dummySignalToRemoveQmlWarning):
        return Qt.UserRole + 1

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def PropertyValue(self):
        return Qt.UserRole + 2

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def PropertyType(self):
        return Qt.UserRole + 3

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def IntegerTypeProperty(self):
        return ValueTypes.IntegerValue.value

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def DoubleTypeProperty(self):
        return ValueTypes.DoubleValue.value

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
        if self._data._valueTypes[index.row()] == ValueTypes.DoubleValue:
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

    def formatPath(self, path):
        result = path.replace("file:///", "")
        if sys.platform == "darwin":
            result = "/" + path
        return result

    @pyqtSlot(str)
    def saveAs(self, path):
        path = self.formatPath(path)
        fh = open(path, "w", encoding='utf-8')
        json.dump( self.settings.serialize(), fh, indent=4, ensure_ascii=False )
        fh.close()

    @pyqtSlot(result=QVariant)
    def getModulationFunctionTypes(self):
        return ModulationFunctions.values()

    @pyqtSlot(result=QVariant)
    def getActiveModulationFunction(self):
        return self.settings.modulation._function.value

    @pyqtSlot(str)
    def loadParamsForFunction(self, funcType):
        wantedFunc = ModulationFunctions.from_value(funcType)
        if wantedFunc == ModulationFunctions.TANH:
            self.settings.modulation._function = ModulationFunctions.TANH
            self.modulationModel.setParameters(self.settings.modulation._tanhModulationParams)
        elif wantedFunc == ModulationFunctions.NONE:
            self.settings.modulation._function = ModulationFunctions.NONE
            self.modulationModel.setParameters(self.settings.modulation._emptyModulationParams)

    @pyqtSlot(str)
    def setPopulationFilePath(self, path):
        self.settings.generalSettings.populationPath = self.formatPath(path)
