import os
import threading
import h5py
from PyQt5.QtCore import pyqtSignal, QObject
import time


class daily_infections_series_preparer(QObject):
    preparing_begin = pyqtSignal(str, arguments=['filename'])
    preparing_done = pyqtSignal()
    series_prepared = pyqtSignal(str, list, arguments=['name', 'series'])
    log_debug = pyqtSignal(str)

    def __init__(self, get_daily_path):
        super().__init__()
        self._dailypath = get_daily_path
        self._condition = threading.Condition()
        self._is_stopped = True
        self._trajectories = {}
        self._PROGRESS_LOG = "Daily Infections Chart: {} / {} {}\n"

    def start_preparing_data(self):
        self.data_thread = threading.Thread(target=self.start_preparing_data_in_thread)
        self.data_thread.start()

    def start_preparing_data_in_thread(self):
        self._is_stopped = False
        dailypath = self._dailypath()
        if is_daily_infections_data_available(dailypath):
            self._trajectories = get_infections_daily(dailypath)
        self.preparing_begin.emit(dailypath)
        self._update_thread = threading.Thread(target=self._send_series)
        self._update_thread.start()

    def on_series_added(self):
        with self._condition:
            self._condition.notify()

    def stop(self):
        self._is_stopped = True
        with self._condition:
            self._condition.notify()
        self._update_thread.join()

    def _log_progress(self, current, max, flag=""):
        self.log_debug.emit(self._PROGRESS_LOG.format(current, max, flag))

    def _send_series(self):
        counter = 0
        self._log_progress(counter, len(self._trajectories))
        for key in self._trajectories:
            self.series_prepared.emit(key, self._trajectories[key])
            counter += 1
            if counter % 50 == 0:
                self._log_progress(counter, len(self._trajectories))
            with self._condition:
                self._condition.wait()
            time.sleep(0.1)
            if self._is_stopped:
                self._log_progress(counter, len(self._trajectories), "[Stopped]")
                break
        if not self._is_stopped:
            self._log_progress(counter, len(self._trajectories), "[Done]")
        self._trajectories.clear()
        self.preparing_done.emit()


def is_daily_infections_data_available(dailyfilepath):
    if not dailyfilepath:
        return False
    if not os.access(dailyfilepath, os.R_OK):
        return False
    fh = h5py.File(dailyfilepath, 'r')
    for tname in fh:
        if list(fh[tname].keys()).index('daily_infections') == -1:
            return False
    return True


def get_infections_daily(inputfilepath):
    result = {}
    if not inputfilepath:
        return result
    trajectories = h5py.File(inputfilepath, 'r')
    for t in trajectories:
        series = []
        ds = trajectories[t]['daily_infections']
        for i in range(0, ds.len()):
            series.append(int(ds[i]))
        result[t] = series
    trajectories.close()
    return result
