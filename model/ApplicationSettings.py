import os
from model.Utilities import formatPath
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal
import logging
import json
from enum import Enum

class ApplicationSettings(QObject):
    _pathToCLI = ""
    _outputDaily = ""
    _outputSummary = ""
    _outputParamsDump = ""
    _outputRunDumpPrefix = ""

    class PropertyNames(Enum):
        PATH_TO_CLI = "path_to_cli"
        OUTPUT_DAILY = "output_daily"
        OUTPUT_SUMMARY = "output_summary"
        OUTPUT_PARAMS_DUMP = "output_params_dump"
        OUTPUT_RUN_DUMP_PREFIX = "output_run_dump_prefix"

    pathToCLIChanged = pyqtSignal()
    outputDailyChanged = pyqtSignal()
    outputSummaryChanged = pyqtSignal()
    outputParamsDumpChanged = pyqtSignal()
    outputRunDumpPrefixChanged = pyqtSignal()

    def getOrEmptyStr(self, data, key):
        if data.get(key) == None:
            return ""
        return data[key]

    def __init__(self):
        try:
            QObject.__init__(self)
            appSettingsFileHandle = open(os.path.join(os.path.dirname(__file__), 'app.settings'), 'rt', encoding='utf-8')
            lines = appSettingsFileHandle.read()
            if not lines:
                appSettingsFileHandle.close()
                return

            content = json.loads(lines)
            self._pathToCLI = self.getOrEmptyStr(content, ApplicationSettings.PropertyNames.PATH_TO_CLI.value)
            self._outputDaily = self.getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_DAILY.value)
            self._outputSummary = self.getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_SUMMARY.value)
            self._outputParamsDump = self.getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_PARAMS_DUMP.value)
            self._outputRunDumpPrefix = self.getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_RUN_DUMP_PREFIX.value)
            appSettingsFileHandle.close()
        except OSError:
            pass

    def __save(self):
        try:
            appSettingsFileHandle = open(os.path.join(os.path.dirname(__file__), 'app.settings'), 'w', encoding='utf-8')
            data = {}
            if self._pathToCLI != "":
                data[ApplicationSettings.PropertyNames.PATH_TO_CLI.value] = self._pathToCLI
            if self._outputDaily != "":
                data[ApplicationSettings.PropertyNames.OUTPUT_DAILY.value] = self._outputDaily
            if self._outputSummary != "":
                data[ApplicationSettings.PropertyNames.OUTPUT_SUMMARY.value] = self._outputSummary
            if self._outputParamsDump != "":
                data[ApplicationSettings.PropertyNames.OUTPUT_PARAMS_DUMP.value] = self._outputParamsDump
            if self._outputRunDumpPrefix != "":
                data[ApplicationSettings.PropertyNames.OUTPUT_RUN_DUMP_PREFIX.value] = self._outputRunDumpPrefix
            json.dump( data, appSettingsFileHandle, indent=4, ensure_ascii=False )
            appSettingsFileHandle.close()
        except OSError:
            pass

    @pyqtProperty(str, notify=pathToCLIChanged)
    def pathToCLI(self):
        return self._pathToCLI

    @pyqtProperty(str, notify=outputDailyChanged)
    def outputDaily(self):
        return self._outputDaily

    @pyqtProperty(str, notify=outputSummaryChanged)
    def outputSummary(self):
        return self._outputSummary

    @pyqtProperty(str, notify=outputParamsDumpChanged)
    def outputParamsDump(self):
        return self._outputParamsDump

    @pyqtProperty(str, notify=outputRunDumpPrefixChanged)
    def outputRunDumpPrefix(self):
        return self._outputRunDumpPrefix

    @pathToCLI.setter
    def pathToCLI(self, path):
        path = formatPath(path)
        if self._pathToCLI != path:
            self._pathToCLI = path
            self.__save()
            self.pathToCLIChanged.emit()

    @outputDaily.setter
    def outputDaily(self, path):
        path = formatPath(path)
        if self._outputDaily != path:
            self._outputDaily = path
            self.__save()
            self.outputDailyChanged.emit()

    @outputSummary.setter
    def outputSummary(self, path):
        path = formatPath(path)
        if self._outputSummary != path:
            self._outputSummary = path
            self.__save()
            self.outputSummaryChanged.emit()

    @outputParamsDump.setter
    def outputParamsDump(self, path):
        path = formatPath(path)
        if self._outputParamsDump != path:
            self._outputParamsDump = path
            self.__save()
            self.outputParamsDumpChanged.emit()

    @outputRunDumpPrefix.setter
    def outputRunDumpPrefix(self, path):
        path = formatPath(path)
        if self._outputRunDumpPrefix != path:
            self._outputRunDumpPrefix = path
            self.__save()
            self.outputRunDumpPrefixChanged.emit()
