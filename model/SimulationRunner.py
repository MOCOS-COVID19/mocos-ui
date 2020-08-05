# This Python file uses the following encoding: utf-8
from PyQt5.QtCore import pyqtSignal, pyqtSlot, QThread, QMutex, QMutexLocker
import subprocess
import os
import enum
import logging
import threading
import queue

def enqueueOutStream(output, q):
    while True:
        line = output.readline()
        if not line:
            break
        q.put(line)

class SimulationRunner(QThread):
    class InitState(enum.Enum):
        NONE = "None"
        INIT = "Initializing"
        STATED = "Stated"
        PARSED_ARGS = "Parsed args"
        LOADING_PARAMS = "loading population and setting up parameters"
        STARTING_SIM = "starting simulation"

    class SimulationState(enum.Enum):
        SIMULATION_ONGOING = "Simulation ongoing"
        STOPPED = "Stopped"
        DONE = "Done"

    pathToCLI = ""
    openedFilePath = ""
    outputDaily = ""
    outputSummary = ""
    outputParamsDump = ""
    outputRunDumpPrefix = ""
    __currentState = InitState.NONE
    __currentProgress = 0
    __process = None
    __mutex = QMutex()
    __isThreadStopped = False

    printSimulationMsg = pyqtSignal(str, arguments=["msg"])
    notifyState = pyqtSignal(str, arguments=["description"])
    notifyProgress = pyqtSignal(float, arguments=["progress"])
    clearLog = pyqtSignal()

    def __init__(self):
        QThread.__init__(self)
        self.notifyProgress.connect(self.__saveCurrentProgress)

    def __del__(self):
        self.wait()

    @pyqtSlot(result=bool)
    def isRunning(self):
        return (isinstance(self.__currentState, SimulationRunner.InitState) and \
            self.__currentState != SimulationRunner.InitState.NONE) or \
            (isinstance(self.__currentState, SimulationRunner.SimulationState) and \
            self.__currentState == SimulationRunner.SimulationState.SIMULATION_ONGOING)

    def __createCommand(self):
        cliname = os.path.basename(self.pathToCLI)
        cmd = ["julia", cliname]
        if self.outputParamsDump:
            cmd.append("--output-params-dump")
            cmd.append(self.outputParamsDump)
        if self.outputDaily:
            cmd.append("--output-daily")
            cmd.append(self.outputDaily)
        if self.outputSummary:
            cmd.append("--output-summary")
            cmd.append(self.outputSummary)
        if self.outputRunDumpPrefix:
            cmd.append("--output-run-dump-prefix")
            cmd.append(self.outputRunDumpPrefix)
        cmd.append(self.openedFilePath)
        return cmd

    def __findSimulationProgressNotif(self, line):
        PROGRESS_STR = "Progress:"
        if line.find(PROGRESS_STR) == -1:
            return None
        max = line.find("%")
        assert(max != -1)
        progressPercent = line[len(PROGRESS_STR) : max].strip()
        return float(progressPercent) / 100.0

    def __findNewStateNotif(self, line):
        if line.find("Info:") == -1:
            return (None, None)
        members = list(SimulationRunner.InitState)
        nextIndex = members.index(self.__currentState) + 1
        if nextIndex >= len(members):
            nextIndex = len(members) - 1
        nextState = members[nextIndex]
        res = line.find(nextState.value)
        return (None, None) if res == -1 else (nextState, nextIndex/(len(members)-1))

    def __isThreadStopped_Safe(self):
        lk = QMutexLocker(self.__mutex)
        return self.__isThreadStopped

    def __setThreadStopped_Safe(self, isStopped):
        lk = QMutexLocker(self.__mutex)
        self.__isThreadStopped = isStopped

    def __saveCurrentProgress(self, progress):
        self.__currentProgress = progress

    @pyqtSlot(result=str)
    def currentState(self):
        return self.__currentState.value

    @pyqtSlot(result=float)
    def currentProgress(self):
        return self.__currentProgress

    def run(self):
        if self.pathToCLI == "" or self.openedFilePath == "":
            return
        self.__currentState = SimulationRunner.InitState.INIT
        self.notifyState.emit(self.__currentState.value)
        self.notifyProgress.emit(0.0)
        self.clearLog.emit()
        dirname = os.path.dirname(self.pathToCLI)
        self.__process = subprocess.Popen(self.__createCommand(), shell=True, \
            cwd=dirname, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, \
            encoding="utf-8")
        if self.__isThreadStopped_Safe():
            self.__currentState = SimulationRunner.InitState.NONE
            return
        communicates = queue.Queue()
        readingOutputThread = threading.Thread(target=enqueueOutStream, args=(self.__process.stdout, communicates))
        readingOutputThread.daemon = True
        readingOutputThread.start()
        while True:
            if self.__isThreadStopped_Safe():
                break
            if self.__process.poll() != None:
                break
            try:
                line = communicates.get(timeout=.1)
            except queue.Empty:
                continue
            self.printSimulationMsg.emit(line)
            state, stateProgress = self.__findNewStateNotif(line)
            if  state != None:
                self.__currentState = state
                self.notifyState.emit(self.__currentState.value)
                self.notifyProgress.emit(stateProgress)
            simProgress = self.__findSimulationProgressNotif(line)
            if simProgress != None:
                self.__currentState = SimulationRunner.SimulationState.SIMULATION_ONGOING
                self.notifyState.emit(self.__currentState.value)
                self.notifyProgress.emit(simProgress)
        if self.__isThreadStopped_Safe():
            self.__currentState = SimulationRunner.SimulationState.STOPPED
            self.__setThreadStopped_Safe(False)
            self.notifyProgress.emit(0.0)
        else:
            self.__currentState = SimulationRunner.SimulationState.DONE
        self.notifyState.emit(self.__currentState.value)

    def stop(self):
        if self.__process != None:
            self.__setThreadStopped_Safe(True)
            self.wait()
            self.__proscess.kill()
            self.__process = None
