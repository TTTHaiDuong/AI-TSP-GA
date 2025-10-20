from PySide6.QtWidgets import QWidget, QVBoxLayout
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure


class RouteCanvas(FigureCanvas):
    """Canvas vẽ đường đi của TSP"""
    def __init__(self, cities, best_route, parent=None):
        # Tạo figure matplotlib
        self.fig = Figure(figsize=(6, 6))
        self.axes = self.fig.add_subplot(111)
        super().__init__(self.fig)
        self.setParent(parent)
        self.plot_route(cities, best_route)

    def plot_route(self, cities, best_route):
        """Vẽ đường đi ngắn nhất"""
        self.axes.clear()

        # Lấy danh sách toạ độ x, y theo thứ tự best_route
        x = [cities[i][0] for i in best_route] + [cities[best_route[0]][0]]
        y = [cities[i][1] for i in best_route] + [cities[best_route[0]][1]]

        # Vẽ các điểm và đường nối
        self.axes.scatter(*zip(*cities), c='red', label='City')
        self.axes.plot(x, y, c='blue', linewidth=1.5, label='Path')

        # Hiển thị số thứ tự của từng thành phố
        for idx, (x_c, y_c) in enumerate(cities):
            self.axes.text(x_c + 0.2, y_c + 0.2, str(idx), fontsize=9)

        self.axes.set_title("TSP Best Route")
        self.axes.legend()
        self.draw()


class RoutePlotWidget(QWidget):
    """Widget chứa biểu đồ để thêm vào giao diện PySide6"""
    def __init__(self, cities, best_route, parent=None):
        super().__init__(parent)
        layout = QVBoxLayout(self)
        self.canvas = RouteCanvas(cities, best_route, self)
        layout.addWidget(self.canvas)
        self.setLayout(layout)

    def update_route(self, cities, best_route):
        """Hàm cho phép cập nhật lại biểu đồ khi có dữ liệu mới"""
        self.canvas.plot_route(cities, best_route)
