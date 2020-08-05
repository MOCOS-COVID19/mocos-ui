import sys

def formatPath(path):
    result = path.replace("file:///", "")
    if sys.platform == "darwin":
        result = "/" + result
    return result
