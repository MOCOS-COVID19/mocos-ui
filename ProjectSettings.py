# This Python file uses the following encoding: utf-8
from enum import Enum
from typing import Union
from PyQt5.QtQml import qmlRegisterType
from PyQt5.QtCore import QObject, QMetaType, pyqtProperty, pyqtSignal

class GeneralSettings(QObject):
    _num_trajectories = 1000
    _population_path = ""
    _detection_mild_probability = 0.3
    _stop_simulation_threshold = 10000

    num_trajectoriesChanged = pyqtSignal(int, arguments=['num_trajectories'])
    population_pathChanged = pyqtSignal(str, arguments=['population_path'])
    detection_mild_probabilityChanged = pyqtSignal(float, arguments=['detection_mild_probability'])
    stop_simulation_thresholdChanged = pyqtSignal(int, arguments=['stop_simulation_threshold'])

    @pyqtProperty(int, notify=num_trajectoriesChanged)
    def num_trajectories(self):
        return self._num_trajectories

    @pyqtProperty(str, notify=population_pathChanged)
    def population_path(self):
        return self._population_path

    @pyqtProperty(float, notify=detection_mild_probabilityChanged)
    def detection_mild_probability(self):
        return self._detection_mild_probability

    @pyqtProperty(int, notify=stop_simulation_thresholdChanged)
    def stop_simulation_threshold(self):
        return self._stop_simulation_threshold

    @num_trajectories.setter
    def num_trajectories(self, val):
        self._num_trajectories = val

    @population_path.setter
    def population_path(self, path):
        self._population_path = path

    @detection_mild_probability.setter
    def detection_mild_probability(self, val):
        self._detection_mild_probability = val

    @stop_simulation_threshold.setter
    def stop_simulation_threshold(self, val):
        self._stop_simulation_threshold = val

    def serialize(self):
        return {
            'num_trajectories' : self._num_trajectories,
            'population_path'  : self._population_path,
            'detection_mild_proba' : self._detection_mild_probability,
            'stop_simulation_threshold' : self._stop_simulation_threshold
        }

class ContactTracking(QObject):
    _probability = 0.5
    _backward_detection_delay = 1.75
    _forward_detection_delay = 1.75
    _testing_time = 0.25

    @pyqtProperty(float)
    def probability(self):
        return self._probability

    @pyqtProperty(float)
    def backward_detection_delay(self):
        return self._backward_detection_delay

    @pyqtProperty(float)
    def forward_detection_delay(self):
        return self._forward_detection_delay

    @pyqtProperty(float)
    def testing_time(self):
        return self._testing_time

    @probability.setter
    def probability(self, val):
        self._probability = val

    @backward_detection_delay.setter
    def backward_detection_delay(self, val):
        self._backward_detection_delay = val

    @forward_detection_delay.setter
    def forward_detection_delay(self, val):
        self._forward_detection_delay = val

    @testing_time.setter
    def testing_time(self, val):
        self._testing_time = val

    def serialize(self):
        return {
            'probability' : self._probability,
            'backward_detection_delay' : self._backward_detection_delay,
            'forward_detection_delay' : self._forward_detection_delay,
            'testing_time' : self._testing_time
        }

class TransmissionProbabilities(QObject):
    _household = 0.3
    _constant = 1.35
    _hospital = 0.0
    _friendship = 0.0

    @pyqtProperty(float)
    def household(self):
        return self._household

    @pyqtProperty(float)
    def constant(self):
        return self._constant

    @pyqtProperty(float)
    def hospital(self):
        return self._hospital

    @pyqtProperty(float)
    def friendship(self):
        return self._friendship

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

    def serialize(self):
        return {
            "household"  : self._household,
            "constant"   : self._constant,
            "hospital"   : self._hospital,
            "friendship" : self._friendship
        }

class ModulationFunctions(Enum):
    NONE = "None"
    TANH = "TanhModulation"

    @staticmethod
    def values():
        l = []
        for f in ModulationFunctions:
            l.append(f.value)
        l.pop(0)
        return l

    @staticmethod
    def from_value(value):
        for funcType in ModulationFunctions:
            if value == funcType.value:
                return funcType
        raise NotImplementedError

class ValueTypes(Enum):
    IntegerValue = 0
    FloatValue = 1

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
            ValueTypes.FloatValue
        ]

class Modulation:
    _function = ModulationFunctions.NONE
    _params = TanhModulationParams()

    def serialize(self):
        return {
            "function" : self._function.value,
            "params" : self._params.serialize()
        }


class Cardinalities(QObject):
    _infectious = 100

    @pyqtProperty(int)
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

    @pyqtProperty(Cardinalities)
    def cardinalities(self):
        return self._cardinalities

    def serialize(self):
        return {
            "cardinalities" : self._cardinalities.serialize()
        }

class PhoneTracking(QObject):
    _usage = 0.0
    _detection_delay = 0.25
    _testing_delay = 1.5

    @pyqtProperty(float)
    def usage(self):
        return self._usage

    @pyqtProperty(float)
    def detection_delay(self):
        return self._detection_delay

    @pyqtProperty(float)
    def testing_delay(self):
        return self._testing_delay

    @usage.setter
    def usage(self, val):
        self._usage = val

    @detection_delay.setter
    def detection_delay(self, val):
        self._detection_delay = val

    @testing_delay.setter
    def testing_delay(self, val):
        self._testing_delay = val

    def serialize(self):
        return {
            "usage" : self._usage,
            "detection_delay" : self._detection_delay,
            "testing_delay" : self._testing_delay
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
        serialized['modulation'] = self.modulation.serialize()
        serialized['phone_tracking'] = self.phoneTracking.serialize()
        return serialized
