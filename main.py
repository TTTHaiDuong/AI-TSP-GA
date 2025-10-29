from PySide6.QtCore import QUrl, QObject, Signal, Slot, Property
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QApplication
import sys
from gui.controllers.fitness import ChartBridge
import random, time
from threading import Thread

def update_chart():
    for i in range(50):
        x = i
        y = random.uniform(0, 10)
        # Gọi hàm appendPoint trong QML
        bridge.add_point(x, y)
        time.sleep(0.2)

    

if __name__ == "__main__":
    print(...)
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    bridge = ChartBridge()
    engine.rootContext().setContextProperty("chartBridge", bridge)

    app.setWindowIcon(QIcon("gui/assets/app_icon.svg"))
    
    engine.load(QUrl("gui/main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    root = engine.rootObjects()[0]
    root.show()
    chart_obj =  root.findChild(QObject, "fitnessChart")

    Thread(target=update_chart, daemon=True).start()


    sys.exit(app.exec())

# import sys
# from PySide6.QtWidgets import QApplication
# from gui.main_window import MainWindow

# if __name__ == "__main__":
#     app = QApplication(sys.argv)
#     window = MainWindow()
#     window.show()
#     sys.exit(app.exec())