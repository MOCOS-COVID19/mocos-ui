# This Python file uses the following encoding: utf-8
from enum import Enum
from typing import Union
from PyQt5.QtQml import qmlRegisterType
from PyQt5.QtCore import QObject, QMetaType, pyqtProperty

class GeneralSettings(QObject):
    _num_trajectories = 1000
    _population_path = ""
    _detection_mild_probability = 0.3
    _stop_simulation_threshold = 10000

    @pyqtProperty(int)
    def num_trajectories(self):
        return self._num_trajectories

    @pyqtProperty(str)
    def population_path(self):
        return self._population_path

    @pyqtProperty(float)
    def detection_mild_probability(self):
        return self._detection_mild_probability

    @pyqtProperty(int)
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

    @backward_detection_delay.setter
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

class TransmissionProbabilities:
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
    TANH = 1

    def __str__(self):
        switcher = {
            ModulationFunctions.TANH : "TanhModulation"
        }
        return switcher.get(self, "invalid")

class TanhModulationParams:
    _scale = 2000
    _loc = 500
    _weight_detected = 1
    _weight_deaths = 0
    _limit_value = 0.5

    def serialize(self):
        return {
            "scale" : self._scale,
            "loc"   : self._loc,
            "weight_detected" : self._weight_detected,
            "weight_deaths" : self._weight_deaths,
            "limit_value" : self._limit_value
        }

class Modulation:
    _function = ModulationFunctions.TANH
    _params = Union[TanhModulationParams]

    def serialize(self):
        return {
            "function" : str(self._function),
            # TODO: "params" : self._params.serialize()
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
