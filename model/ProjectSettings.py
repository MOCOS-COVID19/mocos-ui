# This Python file uses the following encoding: utf-8
from enum import Enum
from typing import Union
from PyQt5.QtQml import qmlRegisterType
from PyQt5.QtCore import QObject, QMetaType, pyqtProperty, pyqtSignal, QVariant

class GeneralSettings(QObject):
    _numTrajectories = 1000
    _populationPath = ""
    _detectionMildProbability = 0.3
    _stopSimulationThreshold = 10000

    numTrajectoriesChanged = pyqtSignal(int, arguments=['value'])
    populationPathChanged = pyqtSignal(str, arguments=['value'])
    detectionMildProbabilityChanged = pyqtSignal(float, arguments=['value'])
    stopSimulationThresholdChanged = pyqtSignal(int, arguments=['value'])

    @pyqtProperty(int, notify=numTrajectoriesChanged)
    def numTrajectories(self):
        return self._numTrajectories

    @pyqtProperty(str, notify=populationPathChanged)
    def populationPath(self):
        return self._populationPath

    @pyqtProperty(float, notify=detectionMildProbabilityChanged)
    def detectionMildProbability(self):
        return self._detectionMildProbability

    @pyqtProperty(int, notify=stopSimulationThresholdChanged)
    def stopSimulationThreshold(self):
        return self._stopSimulationThreshold

    @numTrajectories.setter
    def numTrajectories(self, val):
        self._numTrajectories = val

    @populationPath.setter
    def populationPath(self, path):
        self._populationPath = path
        self.populationPathChanged.emit(path)

    @detectionMildProbability.setter
    def detectionMildProbability(self, val):
        self._detectionMildProbability = val

    @stopSimulationThreshold.setter
    def stopSimulationThreshold(self, val):
        self._stopSimulationThreshold = val

    def serialize(self):
        return {
            'num_trajectories' : self._numTrajectories,
            'population_path'  : self._populationPath,
            'detection_mild_proba' : self._detectionMildProbability,
            'stop_simulation_threshold' : self._stopSimulationThreshold
        }

class ContactTracking(QObject):
    _probability = 0.5
    _backwardDetectionDelay = 1.75
    _forwardDetectionDelay = 1.75
    _testingTime = 0.25

    probabilityChanged = pyqtSignal(float, arguments=['value'])
    backwardDetectionDelayChanged = pyqtSignal(float, arguments=['value'])
    forwardDetectionDelayChanged = pyqtSignal(float, arguments=['value'])
    testingTimeChanged = pyqtSignal(float, arguments=['value'])

    @pyqtProperty(float, notify=probabilityChanged)
    def probability(self):
        return self._probability

    @pyqtProperty(float, notify=backwardDetectionDelayChanged)
    def backwardDetectionDelay(self):
        return self._backwardDetectionDelay

    @pyqtProperty(float, notify=forwardDetectionDelayChanged)
    def forwardDetectionDelay(self):
        return self._forwardDetectionDelay

    @pyqtProperty(float, notify=testingTimeChanged)
    def testingTime(self):
        return self._testingTime

    @probability.setter
    def probability(self, val):
        self._probability = val

    @backwardDetectionDelay.setter
    def backwardDetectionDelay(self, val):
        self._backwardDetectionDelay = val

    @forwardDetectionDelay.setter
    def forwardDetectionDelay(self, val):
        self._forwardDetectionDelay = val

    @testingTime.setter
    def testingTime(self, val):
        self._testingTime = val

    def serialize(self):
        return {
            'probability' : self._probability,
            'backward_detectionDelay' : self._backwardDetectionDelay,
            'forward_detectionDelay' : self._forwardDetectionDelay,
            'testing_time' : self._testingTime
        }

class TransmissionProbabilities(QObject):
    _household = 0.3
    _constant = 1.35
    _hospital = 0.0
    _friendship = 0.0
    _isHouseholdKernelEnabled = _household != 0.0
    _isConstantKernelEnabled = _constant != 0.0
    _isHospitalKernelEnabled = _hospital != 0.0
    _isFriendshipKernelEnabled = _friendship != 0.0

    householdChanged = pyqtSignal(float, arguments=['value'])
    constantChanged = pyqtSignal(float, arguments=['value'])
    hospitalChanged = pyqtSignal(float, arguments=['value'])
    friendshipChanged = pyqtSignal(float, arguments=['value'])

    householdKernelEnabledChanged = pyqtSignal(bool, arguments=['value'])
    constantKernelEnabledChanged = pyqtSignal(bool, arguments=['value'])
    hospitalKernelEnabledChanged = pyqtSignal(bool, arguments=['value'])
    friendshipKernelEnabledChanged = pyqtSignal(bool, arguments=['value'])

    @pyqtProperty(float, notify=householdChanged)
    def household(self):
        return self._household

    @pyqtProperty(float, notify=constantChanged)
    def constant(self):
        return self._constant

    @pyqtProperty(float, notify=hospitalChanged)
    def hospital(self):
        return self._hospital

    @pyqtProperty(float, notify=friendshipChanged)
    def friendship(self):
        return self._friendship

    @pyqtProperty(bool, notify=constantKernelEnabledChanged)
    def isHouseholdKernelEnabled(self):
        return self._isHouseholdKernelEnabled

    @pyqtProperty(bool, notify=constantKernelEnabledChanged)
    def isConstantKernelEnabled(self):
        return self._isConstantKernelEnabled

    @pyqtProperty(bool, notify=hospitalKernelEnabledChanged)
    def isHospitalKernelEnabled(self):
        return self._isHospitalKernelEnabled

    @pyqtProperty(bool, notify=friendshipKernelEnabledChanged)
    def isFriendshipKernelEnabled(self):
        return self._isFriendshipKernelEnabled

    @household.setter
    def household(self, val):
        self._household = val

    @constant.setter
    def constant(self, val):
        self._constant = val

    @hospital.setter
    def hospital(self, val):
        self._hospital = val

    @friendship.setter
    def friendship(self, val):
        self._friendship = val

    @isHouseholdKernelEnabled.setter
    def isHouseholdKernelEnabled(self, value):
        if self._isHouseholdKernelEnabled != value:
            self._isHouseholdKernelEnabled = value
            self.householdKernelEnabledChanged.emit(value)

    @isConstantKernelEnabled.setter
    def isConstantKernelEnabled(self, value):
        if self._isConstantKernelEnabled != value:
            self._isConstantKernelEnabled = value
            self.constantKernelEnabledChanged.emit(value)

    @isHospitalKernelEnabled.setter
    def isHospitalKernelEnabled(self, value):
        if self._isHospitalKernelEnabled != value:
            self._isHospitalKernelEnabled = value
            self.hospitalKernelEnabledChanged.emit(value)

    @isFriendshipKernelEnabled.setter
    def isFriendshipKernelEnabled(self, value):
        if self._isFriendshipKernelEnabled != value:
            self._isFriendshipKernelEnabled = value
            self.friendshipKernelEnabledChanged.emit(value)

    def serialize(self):
        return {
            "household"  : self._household if self._isHouseholdKernelEnabled else 0.0,
            "constant"   : self._constant if self._isConstantKernelEnabled else 0.0,
            "hospital"   : self._hospital if self._isHospitalKernelEnabled else 0.0,
            "friendship" : self._friendship  if self._isFriendshipKernelEnabled else 0.0
        }

class ModulationFunctions(Enum):
    NONE = "None"
    TANH = "TanhModulation"

    @staticmethod
    def values():
        l = []
        for f in ModulationFunctions:
            l.append(f.value)
        return l

    @staticmethod
    def from_value(value):
        for funcType in ModulationFunctions:
            if value == funcType.value:
                return funcType
        raise NotImplementedError

class ValueTypes(Enum):
    IntegerValue = 0
    DoubleValue = 1

class ModulationParams:
    _properties = []
    _values = []
    _valueTypes  = []

    def serialize(self):
        result = {}
        for i in range(0, len(self._properties)):
            result[self._properties[i].lower().replace(" ", "_")] = self._values[i]
        return result

class EmptyModulationParams(ModulationParams):
    def __init__(self):
       super().__init__()

class TanhModulationParams(ModulationParams):
    def __init__(self):
        self._properties = ["Scale", "Loc", "Weight detected", "Weight deaths", "Limit value"]
        self._values = [2000, 500, 1, 0, 0.5]
        self._valueTypes = [
            ValueTypes.IntegerValue,
            ValueTypes.IntegerValue,
            ValueTypes.IntegerValue,
            ValueTypes.IntegerValue,
            ValueTypes.DoubleValue
        ]

class Modulation:
    _function = ModulationFunctions.NONE
    _emptyModulationParams = EmptyModulationParams()
    _tanhModulationParams = TanhModulationParams()

    def getActiveParams(self):
        if _function == ModulationFunctions.NONE:
            return _emptyModulationParams
        elif _function == ModulationFunctions.TANH:
            return _tanhModulationParams
        raise NotImplementedError

    def serialize(self):
        assert(self._function != ModulationFunctions.NONE)
        return {
            "function" : self._function.value,
            "params" : self._tanhModulationParams.serialize()
        }


class Cardinalities(QObject):
    _infectious = 100

    infectiousChanged = pyqtSignal(int, arguments=["value"])

    @pyqtProperty(int, notify=infectiousChanged)
    def infectious(self):
        return self._infectious

    @infectious.setter
    def infectious(self, val):
        self._infectious = val

    def serialize(self):
        return {
            "infectious" : self._infectious
        }

class InitialConditions(QObject):
    _cardinalities = Cardinalities()

    cardinalitiesChanged = pyqtSignal(QVariant, arguments=["value"])

    @pyqtProperty(Cardinalities, notify=cardinalitiesChanged)
    def cardinalities(self):
        return self._cardinalities

    def serialize(self):
        return {
            "cardinalities" : self._cardinalities.serialize()
        }

class PhoneTracking(QObject):
    _usage = 0.0
    _detectionDelay = 0.25
    _testingDelay = 1.5

    usageChanged = pyqtSignal(float, arguments=["value"])
    detectionDelayChanged = pyqtSignal(float, arguments=["value"])
    testingDelayChanged = pyqtSignal(float, arguments=["value"])

    @pyqtProperty(float, notify=usageChanged)
    def usage(self):
        return self._usage

    @pyqtProperty(float, notify=detectionDelayChanged)
    def detectionDelay(self):
        return self._detectionDelay

    @pyqtProperty(float, notify=testingDelayChanged)
    def testingDelay(self):
        return self._testingDelay

    @usage.setter
    def usage(self, val):
        self._usage = val

    @detectionDelay.setter
    def detectionDelay(self, val):
        self._detectionDelay = val

    @testingDelay.setter
    def testingDelay(self, val):
        self._testingDelay = val

    def serialize(self):
        return {
            "usage" : self._usage,
            "detection_delay" : self._detectionDelay,
            "testing_delay" : self._testingDelay
        }

class ProjectSettings:
    initialConditions = InitialConditions()
    generalSettings = GeneralSettings()
    contactTracking = ContactTracking()
    transmissionProbabilities = TransmissionProbabilities()
    modulation = Modulation()
    phoneTracking = PhoneTracking()

    def serialize(self):
        serialized = self.generalSettings.serialize()
        serialized['initial_conditions'] = self.initialConditions.serialize()
        serialized['contact_tracking'] = self.contactTracking.serialize()
        serialized['transmission_probabilities'] = self.transmissionProbabilities.serialize()
        if (self.modulation._function != ModulationFunctions.NONE):
            serialized['modulation'] = self.modulation.serialize()
        serialized['phone_tracking'] = self.phoneTracking.serialize()
        return serialized
