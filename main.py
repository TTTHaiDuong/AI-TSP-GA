import sys
from PySide6.QtCore import QUrl
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QApplication

# === BƯỚC 1: IMPORT QQuickStyle ===
from PySide6.QtQuickControls2 import QQuickStyle

# Import controller của chúng ta
from gui.controllers.fitness import AppController

if __name__ == "__main__":
    app = QApplication(sys.argv)

    # === BƯỚC 2: SET STYLE NGAY TỪ ĐẦU ===
    # Dòng này ra lệnh cho toàn bộ ứng dụng sử dụng giao diện Material.
    # Nó phải được gọi trước khi engine load file QML.
    QQuickStyle.setStyle("Material")

    engine = QQmlApplicationEngine()

    # Tạo đối tượng controller
    controller = AppController()

    # Đặt controller vào context của QML với tên là "appController"
    engine.rootContext().setContextProperty("appController", controller)

    app.setWindowIcon(QIcon("gui/assets/app_icon.svg"))

    engine.load(QUrl("gui/main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())