# This Python file uses the following encoding: utf-8
import sys
import os
from model.ProjectHandler import ProjectHandler
from model.ProjectSettings import Cardinalities, ModulationFunctions
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine, QQmlEngine, qmlRegisterType
import PyQt5.QtCore
import logging

def shutdown():
    del globals()["engine"]

if __name__ == "__main__":
    projectHandler = ProjectHandler()
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.DEBUG)

    qmlRegisterType(Cardinalities, "ProjectSettingTypes", 1, 0, "Cardinalities")

    QGuiApplication.setAttribute(PyQt5.QtCore.Qt.AA_EnableHighDpiScaling, True)
    QGuiApplication.setAttribute(PyQt5.QtCore.Qt.AA_UseHighDpiPixmaps, True)

    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    app.aboutToQuit.connect(shutdown)
    app.setApplicationName("MOCOS")
    app.setOrganizationDomain("mocos.pl")

    engine.rootContext().setContextProperty("projectHandler", projectHandler)
    engine.rootContext().setContextProperty("initialConditions", projectHandler._settings.initialConditions)
    engine.rootContext().setContextProperty("transmissionProbabilities", projectHandler._settings.transmissionProbabilities)
    engine.rootContext().setContextProperty("generalSettings", projectHandler._settings.generalSettings)
    engine.rootContext().setContextProperty("phoneTracking", projectHandler._settings.phoneTracking)
    engine.rootContext().setContextProperty("contactTracking", projectHandler._settings.contactTracking)
    engine.rootContext().setContextProperty("modulationModel", projectHandler._modulationModel)
    engine.rootContext().setContextProperty("applicationSettings", projectHandler._applicationSettings)
    engine.rootContext().setContextProperty("simulationRunner", projectHandler._simulationRunner)

    engine.load(PyQt5.QtCore.QUrl("file:///" + os.path.dirname(os.path.abspath(__file__)) + "/views/MainWindow.qml"))

    wnd = engine.rootObjects()[0]
    wnd.show()
    sys.exit(app.exec_())
