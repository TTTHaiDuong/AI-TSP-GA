# gui/controllers/fitness.py
from PySide6.QtCore import QObject, Signal, Slot, QPointF

class ChartBridge(QObject):
    # Tín hiệu gửi list điểm (dạng [{x:..., y:...}, ...]) sang QML
    pointAdded = Signal(QPointF)

    # @Slot()
    def add_point(self, x, y):
        pt = QPointF(x, y)
        self.pointAdded.emit(pt)

    @Slot(str, result=str)
    def from_message(self, msg):
        print(msg)
        return "Hi QML!"