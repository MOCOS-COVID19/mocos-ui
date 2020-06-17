# This Python file uses the following encoding: utf-8
import sys
import os
from ProjectHandler import *
from ProjectSettings import GeneralSettings, Cardinalities
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine, qmlRegisterType
from PyQt5.QtCore import *
import logging

if __name__ == "__main__":
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.DEBUG)

    projectHandler = ProjectHandler()

    qmlRegisterType(Cardinalities, "ProjectSettingTypes", 1, 0, "Cardinalities")

    app = QGuiApplication([])
    engine = QQmlApplicationEngine(QUrl("file:///" + os.path.dirname(__file__) + "/MainWindow.qml"))

    engine.rootContext().setContextProperty("projectHandler", projectHandler)
    engine.rootContext().setContextProperty("initialConditions", projectHandler.settings.initialConditions)
    engine.rootContext().setContextProperty("generalSettings", projectHandler.settings.generalSettings)
    engine.rootContext().setContextProperty("phoneTracking", projectHandler.settings.phoneTracking)
    engine.rootContext().setContextProperty("contactTracking", projectHandler.settings.contactTracking)

    wnd = engine.rootObjects()[0]
    wnd.saveProjectAs.connect(projectHandler.saveAs)

    wnd.show()
    sys.exit(app.exec_())
