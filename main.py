from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

app = QGuiApplication([])
engine = QQmlApplicationEngine()

engine.load("gui/main.qml")

if not engine.rootObjects():
    raise SystemExit("QML file not loaded correctly!")

app.exec()