import h5py
import os


def get_infections_daily(inputfilepath):
    trajectories = h5py.File(inputfilepath, 'r')
    result = {}
    for t in trajectories:
        data_per_t = []
        ds = trajectories[t]['daily_infections']
        for i in range(0, ds.len()):
            data_per_t.append(int(ds[i]))
        result[t] = data_per_t
    trajectories.close()
    return result


def is_daily_infections_chart_available(dailyfilepath):
    if not os.access(dailyfilepath, os.R_OK):
        return False
    fh = h5py.File(dailyfilepath, 'r')
    for tname in fh:
        if list(fh[tname].keys()).index('daily_infections') == -1:
            return False
    return True
