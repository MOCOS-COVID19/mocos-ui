import os
from model.Utilities import formatPath, getOrEmptyStr, getOr
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal
import logging
import json
from enum import Enum

class ApplicationSettings(QObject):
    _juliaCommand = "julia"
    _outputDaily = ""
    _outputSummary = ""
    _outputParamsDump = ""
    _outputRunDumpPrefix = ""

    class PropertyNames(Enum):
        JULIA_COMMAND = "julia_command"
        OUTPUT_DAILY = "output_daily"
        OUTPUT_SUMMARY = "output_summary"
        OUTPUT_PARAMS_DUMP = "output_params_dump"
        OUTPUT_RUN_DUMP_PREFIX = "output_run_dump_prefix"

    juliaCommandChanged = pyqtSignal()
    outputDailyChanged = pyqtSignal()
    outputSummaryChanged = pyqtSignal()
    outputParamsDumpChanged = pyqtSignal()
    outputRunDumpPrefixChanged = pyqtSignal()

    def __init__(self):
        try:
            QObject.__init__(self)
            appSettingsFileHandle = open(os.path.join(os.path.dirname(__file__), 'app.settings'), 'rt', encoding='utf-8')
            lines = appSettingsFileHandle.read()
            if not lines:
                appSettingsFileHandle.close()
                return

            content = json.loads(lines)
            self._juliaCommand = getOr(content, ApplicationSettings.PropertyNames.JULIA_COMMAND.value, "julia")
            self._outputDaily = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_DAILY.value)
            self._outputSummary = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_SUMMARY.value)
            self._outputParamsDump = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_PARAMS_DUMP.value)
            self._outputRunDumpPrefix = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_RUN_DUMP_PREFIX.value)
            appSettingsFileHandle.close()
        except OSError:
            pass

    def __save(self):
        try:
            appSettingsFileHandle = open(os.path.join(os.path.dirname(__file__), 'app.settings'), 'w', encoding='utf-8')
            data = {}
            if self._juliaCommand != "":
                data[ApplicationSettings.PropertyNames.JULIA_COMMAND.value] = self._juliaCommand
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

    @pyqtProperty(str, notify=juliaCommandChanged)
    def juliaCommand(self):
        return self._juliaCommand

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

    @juliaCommand.setter
    def juliaCommand(self, cmd):
        if cmd != "julia":
            cmd = formatPath(cmd)
        if self._juliaCommand != cmd:
            self._juliaCommand = cmd
            self.__save()
            self.juliaCommandChanged.emit()

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
