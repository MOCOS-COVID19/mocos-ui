import os
from model.Utilities import formatPath, getOrEmptyStr, getOr
from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot
import json
from enum import Enum


class ApplicationSettings(QObject):
    juliaCommandChanged = pyqtSignal()
    outputDailyChanged = pyqtSignal()
    outputSummaryChanged = pyqtSignal()
    outputParamsDumpChanged = pyqtSignal()
    outputRunDumpPrefixChanged = pyqtSignal()
    juliaCommandAcceptabilityCheckReq = pyqtSignal()
    outputDailyAcceptabilityCheckReq = pyqtSignal()
    outputSummaryAcceptabilityCheckReq = pyqtSignal()
    outputParamsDumpAcceptabilityCheckReq = pyqtSignal()
    outputRunDumpPrefixAcceptabilityCheckReq = pyqtSignal()
    numOfThreadsChanged = pyqtSignal()
    recentFilesChanged = pyqtSignal()

    class PropertyNames(Enum):
        JULIA_COMMAND = "julia_command"
        OUTPUT_DAILY = "output_daily"
        OUTPUT_SUMMARY = "output_summary"
        OUTPUT_PARAMS_DUMP = "output_params_dump"
        OUTPUT_RUN_DUMP_PREFIX = "output_run_dump_prefix"
        NUM_OF_THREADS = "num_of_threads"

    def __init__(self, getworkdir):
        super().__init__()
        self._getworkdir = getworkdir
        self._juliaCommand = "julia"
        self._outputDaily = ""
        self._outputSummary = ""
        self._outputParamsDump = ""
        self._outputRunDumpPrefix = ""
        self._numOfThreads = 1
        self._recentFiles = []
        self.__loadRecentFiles()
        self.__loadCliOptions()

    def __loadRecentFiles(self):
        try:
            recentFileHandle = open(
                os.path.join(os.path.dirname(__file__), '.recent'),
                'rt', encoding='utf-8')
            lines = recentFileHandle.read().split('\n')
            recentFileHandle.close()
            for path in lines:
                if path:
                    self._recentFiles.append(path)
        except OSError:
            pass

    def __loadCliOptions(self):
        try:
            appSettingsFileHandle = open(
                os.path.join(os.path.dirname(__file__), '.cli_options'),
                'rt', encoding='utf-8')
            lines = appSettingsFileHandle.read()
            appSettingsFileHandle.close()
            if lines:
                content = json.loads(lines)
                self._outputDaily = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_DAILY.value)
                self._outputSummary = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_SUMMARY.value)
                self._outputParamsDump = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_PARAMS_DUMP.value)
                self._outputRunDumpPrefix = getOrEmptyStr(content, ApplicationSettings.PropertyNames.OUTPUT_RUN_DUMP_PREFIX.value)
                self._numOfThreads = getOr(content, ApplicationSettings.PropertyNames.NUM_OF_THREADS.value, 1)
                if self._numOfThreads > self.getMaxNumOfThreads():
                    self._numOfThreads = self.getMaxNumOfThreads()
        except OSError:
            pass

    def __saveCliOptions(self):
        try:
            appSettingsFileHandle = open(
                os.path.join(os.path.dirname(__file__), '.cli_options'),
                'w', encoding='utf-8')
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
            data[ApplicationSettings.PropertyNames.NUM_OF_THREADS.value] = self._numOfThreads
            json.dump(data, appSettingsFileHandle, indent=4, ensure_ascii=False)
            appSettingsFileHandle.close()
        except OSError:
            pass

    def recheckPaths(self):
        self.juliaCommandAcceptabilityCheckReq.emit()
        self.outputDailyAcceptabilityCheckReq.emit()
        self.outputSummaryAcceptabilityCheckReq.emit()
        self.outputParamsDumpAcceptabilityCheckReq.emit()
        self.outputRunDumpPrefixAcceptabilityCheckReq.emit()

    def __saveRecentFiles(self):
        try:
            recentFileHandle = open(os.path.join(os.path.dirname(__file__), '.recent'), 'w', encoding='utf-8')
            for path in self._recentFiles:
                recentFileHandle.write(path + '\n')
        except OSError:
            pass

    def setAsRecentFile(self, path):
        try:
            foundId = self._recentFiles.index(path)
            self._recentFiles[0], self._recentFiles[foundId] = self._recentFiles[foundId], self._recentFiles[0]
        except ValueError:
            self._recentFiles.insert(0, path)
            while len(self._recentFiles) <= 2:
                del self._recentFiles[-1]
        self.recentFilesChanged.emit()
        self.__saveRecentFiles()

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

    def __isPathToOutputFileJld2Correct(self, relpath):
        fullpath = formatPath(self._getworkdir() + "\\" + relpath)
        return (os.path.dirname(fullpath) != fullpath
                and relpath.endswith(".jld2")
                and os.access(os.path.dirname(fullpath), os.W_OK))

    @pyqtProperty(bool, notify=juliaCommandAcceptabilityCheckReq)
    def juliaCommandAcceptable(self):
        return (self._juliaCommand == "julia"
                or os.access(self._juliaCommand, os.X_OK))

    @pyqtProperty(bool, notify=outputDailyAcceptabilityCheckReq)
    def outputDailyAcceptable(self):
        return (self._outputDaily == ""
                or self.__isPathToOutputFileJld2Correct(self._outputDaily))

    @pyqtProperty(bool, notify=outputSummaryAcceptabilityCheckReq)
    def outputSummaryAcceptable(self):
        return (self._outputSummary == ""
                or self.__isPathToOutputFileJld2Correct(self._outputSummary))

    @pyqtProperty(bool, notify=outputParamsDumpAcceptabilityCheckReq)
    def outputParamsDumpAcceptable(self):
        return (self._outputParamsDump == ""
                or self.__isPathToOutputFileJld2Correct(self._outputParamsDump))

    @pyqtProperty(bool, notify=outputRunDumpPrefixAcceptabilityCheckReq)
    def outputRunDumpPrefixAcceptable(self):
        fullpath = formatPath(self._getworkdir() + "\\" + self._outputRunDumpPrefix)
        return (self._outputRunDumpPrefix == ""
                or (os.path.dirname(fullpath) != fullpath
                    and os.access(os.path.dirname(fullpath), os.W_OK)))

    @pyqtProperty(int, notify=numOfThreadsChanged)
    def numOfThreads(self):
        return self._numOfThreads

    @pyqtProperty(list, notify=recentFilesChanged)
    def recentFiles(self):
        return self._recentFiles

    @juliaCommand.setter
    def juliaCommand(self, cmd):
        if cmd != "julia":
            cmd = formatPath(cmd)
        if self._juliaCommand != cmd:
            self._juliaCommand = cmd
            self.__saveCliOptions()
            self.juliaCommandChanged.emit()
            self.juliaCommandAcceptabilityCheckReq.emit()

    @outputDaily.setter
    def outputDaily(self, path):
        newpath = formatPath(path, makeRelativeTo=self._getworkdir())
        if self._outputDaily != path:
            self._outputDaily = newpath
            self.__saveCliOptions()
            self.outputDailyChanged.emit()
            self.outputDailyAcceptabilityCheckReq.emit()

    @outputSummary.setter
    def outputSummary(self, path):
        newpath = formatPath(path, makeRelativeTo=self._getworkdir())
        if self._outputSummary != path:
            self._outputSummary = newpath
            self.__saveCliOptions()
            self.outputSummaryChanged.emit()
            self.outputSummaryAcceptabilityCheckReq.emit()

    @outputParamsDump.setter
    def outputParamsDump(self, path):
        newpath = formatPath(path, makeRelativeTo=self._getworkdir())
        if self._outputParamsDump != path:
            self._outputParamsDump = newpath
            self.__saveCliOptions()
            self.outputParamsDumpChanged.emit()
            self.outputParamsDumpAcceptabilityCheckReq.emit()

    @outputRunDumpPrefix.setter
    def outputRunDumpPrefix(self, path):
        newpath = formatPath(path, makeRelativeTo=self._getworkdir())
        if self._outputRunDumpPrefix != path:
            self._outputRunDumpPrefix = newpath
            self.__saveCliOptions()
            self.outputRunDumpPrefixChanged.emit()
            self.outputRunDumpPrefixAcceptabilityCheckReq.emit()

    @numOfThreads.setter
    def numOfThreads(self, threadsNum):
        value = int(threadsNum)
        if value >= 1 and value <= self.getMaxNumOfThreads():
            self._numOfThreads = value
            self.__saveCliOptions()
        self.numOfThreadsChanged.emit()

    @pyqtSlot(result=int)
    def getMaxNumOfThreads(self):
        return os.cpu_count()
