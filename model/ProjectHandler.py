# This Python file uses the following encoding: utf-8
from model.ProjectSettings import *
import json
from PyQt5.QtCore import QAbstractTableModel, pyqtSignal, pyqtSlot, Qt, QByteArray, QObject
from PyQt5.QtWidgets import QFileDialog
import sys
import os
from model.ConfigurationValidator import ConfigurationValidator
from model.Utilities import formatPath
from model.ApplicationSettings import ApplicationSettings
from model.SimulationRunner import SimulationRunner
from jsonschema import ValidationError
import logging
import subprocess

class FunctionParametersModel(QAbstractTableModel):
    dummySignalToRemoveQmlWarning = pyqtSignal(int)
    numOfDataChangedToOmit = 0

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
    def PositiveIntegerTypeProperty(self):
        return ValueTypes.PositiveIntegerValue.value

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def PositiveDoubleTypeProperty(self):
        return ValueTypes.PositiveDoubleValue.value

    @pyqtProperty(int, notify=dummySignalToRemoveQmlWarning)
    def InfiniteDoubleTypeProperty(self):
        return ValueTypes.InfiniteDoubleValue.value

    _data = EmptyModulationParams()

    @pyqtSlot(int, result=QVariant)
    def getPropertyType(self, row):
        return self.data(self.index(row, 1), self.PropertyType)

    def setParameters(self, newData):
        # Flow:
        # loading ModulationSettingsView -> call to loadParamsForFunction(isModifyingConf=false)
        # -> setParameters -> layoutChanged.emit() -> N times call to data/setData
        # -> emit dataChanged -> setModifiedToTrue
        # We don't want to call setModifiedToTrue when the setData is triggered from this
        # function because it puts "*" to window title indicating that opened configuration
        # was modified which is not true during initialization phase of ModulationSettingsView's
        # load.
        maxRowsNum = max(len(newData._properties), len(self._data._properties))
        self.numOfDataChangedToOmit = maxRowsNum
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
        if self._data._valueTypes[index.row()] == ValueTypes.PositiveIntegerValue:
            self._data._values[index.row()] = int(value)
            self.notifyDataChanged(index, index)
            return True
        if self._data._valueTypes[index.row()] == ValueTypes.PositiveDoubleValue or \
           self._data._valueTypes[index.row()] == ValueTypes.InfiniteDoubleValue:
            self._data._values[index.row()] = value
            self.notifyDataChanged(index, index)
            return True
        return False

    def roleNames(self):
        return {
            self.PropertyName  : QByteArray().append("propertyName"),
            self.PropertyValue : QByteArray().append("propertyValue"),
            self.PropertyType  : QByteArray().append("propertyType")
        }

    def notifyDataChanged(self, topLeft, bottomRight):
        assert(self.numOfDataChangedToOmit >= 0)
        if self.numOfDataChangedToOmit > 0:
            self.numOfDataChangedToOmit -= 1
        else:
            self.dataChanged.emit(topLeft, bottomRight)

class ProjectHandler(QObject):
    _settings = ProjectSettings()
    _modulationModel = FunctionParametersModel()
    _applicationSettings = ApplicationSettings()
    _simulationRunner = SimulationRunner()

    _openedFilePath = None
    _isOpenedConfModified = False
    _isModifyingConfOngoing = True

    __runSimulationAfterSaving = False 

    showErrorMsg = pyqtSignal(str, arguments=['msg'])
    modulationFunctionChanged = pyqtSignal()
    openedNewConf = pyqtSignal()
    openedConfModified = pyqtSignal()
    requestSavingConfiguration = pyqtSignal()

    def setOpenedConfModifiedIfModificationOngoing(self):
        if self._isModifyingConfOngoing:
            self.setOpenedConfModified(True)

    def __init__(self):
        super().__init__()
        setModifiedToTrue = lambda: self.setOpenedConfModifiedIfModificationOngoing()
        self._settings.generalSettings.numTrajectoriesChanged.connect(setModifiedToTrue)
        self._settings.generalSettings.populationPathChanged.connect(setModifiedToTrue)
        self._settings.generalSettings.detectionMildProbabilityChanged.connect(setModifiedToTrue)
        self._settings.generalSettings.stopSimulationThresholdChanged.connect(setModifiedToTrue)
        self._settings.initialConditions.cardinalities.infectiousChanged.connect(setModifiedToTrue)
        self._settings.contactTracking.probabilityChanged.connect(setModifiedToTrue)
        self._settings.contactTracking.backwardDetectionDelayChanged.connect(setModifiedToTrue)
        self._settings.contactTracking.forwardDetectionDelayChanged.connect(setModifiedToTrue)
        self._settings.contactTracking.testingTimeChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.householdChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.constantChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.hospitalChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.friendshipChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.householdKernelEnabledChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.constantKernelEnabledChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.hospitalKernelEnabledChanged.connect(setModifiedToTrue)
        self._settings.transmissionProbabilities.friendshipKernelEnabledChanged.connect(setModifiedToTrue)
        self._settings.phoneTracking.usageChanged.connect(setModifiedToTrue)
        self._settings.phoneTracking.detectionDelayChanged.connect(setModifiedToTrue)
        self._settings.phoneTracking.usageByHouseholdChanged.connect(setModifiedToTrue)
        self._modulationModel.dataChanged.connect(lambda tr, bl, role: setModifiedToTrue())

    @pyqtSlot(str)
    def saveAs(self, path):
        path = formatPath(path)
        fh = open(path, "w", encoding='utf-8')
        json.dump( self._settings.serialize(), fh, indent=4, ensure_ascii=False )
        fh.close()
        self._openedFilePath = path
        self.openedNewConf.emit()
        self.setOpenedConfModified(False)
        if self.__runSimulationAfterSaving:
            self.__runSimulationAfterSaving = False
            self.runSimulation()

    @pyqtSlot()
    def quickSave(self):
        assert(self._openedFilePath != None)
        self.saveAs(self._openedFilePath)

    @pyqtSlot(str)
    def open(self, path):
        try:
            path = formatPath(path)
            inputFileHandle = open(path, 'r', encoding='utf-8')
            data = json.loads(inputFileHandle.read())
            ConfigurationValidator.validateAgainstSchema(data)
            self._settings.populate(data)
            self.modulationFunctionChanged.emit()
            self._openedFilePath = path
            self._isOpenedConfModified = False
            self.openedNewConf.emit()
        except FileNotFoundError as error:
            self.showErrorMsg.emit(str(error))
        except json.decoder.JSONDecodeError as error:
            self.showErrorMsg.emit("File: json schema is corrupted: {0}".format(str(error)))
        except ValidationError as error:
            self.showErrorMsg.emit("Unable to open file at: {0} due to wrong input data: {1}".format(path, str(error)))

    @pyqtSlot(result=str)
    def getOpenedConfName(self):
        if self._openedFilePath == None:
            return "new"
        else:
            return self._openedFilePath

    @pyqtSlot(result=bool)
    def isConfirationOpenedFromFile(self):
        return self._openedFilePath != None

    @pyqtSlot(result=bool)
    def isOpenedConfModified(self):
        return self._isOpenedConfModified

    def setOpenedConfModified(self, isModified=True):
        if self._isOpenedConfModified != isModified:
            self._isOpenedConfModified = isModified
            self.openedConfModified.emit()

    @pyqtSlot(result=QVariant)
    def getModulationFunctionTypes(self):
        return ModulationFunctions.values()

    @pyqtSlot(result=QVariant)
    def getActiveModulationFunction(self):
        return self._settings.modulation._function.value

    @pyqtSlot(str, bool)
    def loadParamsForFunction(self, funcType, isModifyingConf):
        self._isModifyingConfOngoing = isModifyingConf
        wantedFunc = ModulationFunctions.from_value(funcType)
        if wantedFunc == ModulationFunctions.TANH:
            self._settings.modulation._function = ModulationFunctions.TANH
            self._modulationModel.setParameters(self._settings.modulation._tanhModulationParams)
        elif wantedFunc == ModulationFunctions.NONE:
            self._settings.modulation._function = ModulationFunctions.NONE
            self._modulationModel.setParameters(self._settings.modulation._emptyModulationParams)
        if self._isModifyingConfOngoing:
            self.setOpenedConfModified(True)
        else:
            self._isModifyingConfOngoing = True

    @pyqtSlot(str)
    def setPopulationFilePath(self, path):
        self._settings.generalSettings.populationPath = formatPath(path)

    @pyqtSlot()
    def runSimulation(self):
        if not self._settings.generalSettings._populationPath:
            self.showErrorMsg.emit("Simulation can't be run: population path not defined.")
            return
        if not self._applicationSettings.juliaCommandAcceptable or \
           not self._applicationSettings.outputDailyAcceptable or \
           not self._applicationSettings.outputSummaryAcceptable or \
           not self._applicationSettings.outputParamsDumpAcceptable or \
           not self._applicationSettings.outputRunDumpPrefixAcceptable:
            self.showErrorMsg.emit("Simulation can't be run: simulation settings incorrect.")
            return


        if not self._openedFilePath:
            self.__runSimulationAfterSaving = True
            self.requestSavingConfiguration.emit()
            return
        self._simulationRunner.openedFilePath = self._openedFilePath
        self._simulationRunner.juliaCommand = self._applicationSettings.juliaCommand
        self._simulationRunner.outputDaily = self._applicationSettings.outputDaily
        self._simulationRunner.outputSummary = self._applicationSettings.outputSummary
        self._simulationRunner.outputParamsDump = self._applicationSettings.outputParamsDump
        self._simulationRunner.outputRunDumpPrefix = self._applicationSettings.outputRunDumpPrefix
        self._simulationRunner.start()

    @pyqtSlot()
    def stopSimulation(self):
        self._simulationRunner.stop()
