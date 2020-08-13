import sys

def formatPath(path):
    result = path.replace("file:///", "")
    result = result.replace('\\', '/')
    if sys.platform == "darwin" and path != "":
        result = "/" + result
    return result

def getOrEmptyStr(data, key):
    if data.get(key) == None:
        return ""
    return data[key]

def getOr(data, key, alternative):
    if data.get(key) == None:
        return alternative
    return data[key]
