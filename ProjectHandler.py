# This Python file uses the following encoding: utf-8
from ProjectSettings import *
import logging
import json
from PyQt5.QtCore import QObject, pyqtSlot

class ProjectHandler(QObject):
    settings = ProjectSettings()

    def saveAs(self, path):
        logging.debug("before: " + path)
        path = path.replace("file:///", "")
        logging.debug("after: " + path)
        fh = open(path, "w", encoding='utf-8')
        json.dump( self.settings.serialize(), fh, indent=4, ensure_ascii=False )
        fh.close()
