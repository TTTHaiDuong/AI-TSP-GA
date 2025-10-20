from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

import sys

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()

# engine.addImportPath("gui")
# engine.addImportPath("gui/components")
engine.load(QUrl.fromLocalFile("gui/main.qml"))

if not engine.rootObjects():
    # raise SystemExit("QML file not loaded correctly!")
    pass
else:
    print("QML OK!")
    engine.rootObjects()[0].show()

sys.exit(app.exec())