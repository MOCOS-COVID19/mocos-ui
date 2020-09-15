import os


def format_path(path, isFile=True, makeRelativeTo=None):
    result = path.replace("file:///", "")
    result = result.replace('\\', '/')
    if isFile and len(result) > 2 and result.endswith('/'):
        result = result[:-1]
    if os.path.isabs(result) and makeRelativeTo:
        result = os.path.relpath(result, format_path(makeRelativeTo, isFile=False))
        result = result.replace('\\', '/')
    return result


def get_or_empty_str(data, key):
    if data.get(key) is None:
        return ""
    return data[key]


def get_or(data, key, alternative):
    if data.get(key) is None:
        return alternative
    return data[key]


def ABS_PATH_TO_ADVANCED_CLI():
    return os.path.dirname(os.path.dirname(os.path.realpath(__file__)).replace('\\', '/') +
                           "/../3rdparty/MocosSimLauncher/")
