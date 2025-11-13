from PySide6.QtCore import QUrl, QObject
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtGui import QIcon

from gui.controllers.fitness_chart import FitnessBridge
from gui.controllers.route_map import RouteBridge
from gui.controllers.optimize import OptimizationBridge

import sys
    

if __name__ == "__main__":
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    fitnessbridge = FitnessBridge()
    routeBridge = RouteBridge()
    optimizationBridge = OptimizationBridge()
    
    engine.rootContext().setContextProperty("chartBridge", fitnessbridge)
    engine.rootContext().setContextProperty("routeBridge", routeBridge)
    engine.rootContext().setContextProperty("optimizationBridge", optimizationBridge)

    app.setWindowIcon(QIcon("gui/assets/app_icon.svg"))
    
    engine.load(QUrl("gui/main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    root = engine.rootObjects()[0]
    root.show()
    chart_obj =  root.findChild(QObject, "fitnessChart")

    sys.exit(app.exec())