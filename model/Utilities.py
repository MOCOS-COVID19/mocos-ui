import sys
import os
import logging

def formatPath(path, isFile=True, makeRelativeTo=None):
    result = path.replace("file:///", "")
    result = result.replace('\\', '/')
    if sys.platform == "darwin" and path != "":
        result = "/" + result
    if isFile and len(result) > 2 and result.endswith('/'):
        result = result[:-1]
    if makeRelativeTo and os.path.isabs(result):
        result = os.path.relpath(result, formatPath(makeRelativeTo))
        result = result.replace('\\', '/')
    return result

def getOrEmptyStr(data, key):
    if data.get(key) == None:
        return ""
    return data[key]

def getOr(data, key, alternative):
    if data.get(key) == None:
        return alternative
    return data[key]

def ABS_PATH_TO_ADVANCED_CLI():
    return os.path.dirname(os.path.dirname(os.path.realpath(__file__)).replace('\\', '/') + \
        "/../3rdparty/modelling-ncov2019/julia/src/")
