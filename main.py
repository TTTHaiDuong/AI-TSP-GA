from PySide6.QtCore import QUrl
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtGui import QIcon

from gui.controllers.route_map import RouteBridge
from gui.controllers.run_algo import RunAlgorithmsBridge
from gui.controllers.cost_matrix import CostMatrixBridge

import sys
    

if __name__ == "__main__":
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    route_bridge = RouteBridge()
    optimization_bridge = RunAlgorithmsBridge()
    cost_matrix_bridge = CostMatrixBridge()
    
    engine.rootContext().setContextProperty("routeBridge", route_bridge)
    engine.rootContext().setContextProperty("optimizationBridge", optimization_bridge)
    engine.rootContext().setContextProperty("costMatrixBridge", cost_matrix_bridge)

    app.setWindowIcon(QIcon("gui/assets/app_icon.svg"))
    
    engine.load(QUrl("gui/main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    root = engine.rootObjects()[0]
    root.show() # type: ignore

    sys.exit(app.exec())