from PySide6.QtWidgets import QWidget, QVBoxLayout, QTabWidget
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg as FigureCanvas


class PlotTabs(QWidget):
    """Widget chứa các tab để hiển thị biểu đồ Route và Fitness."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.layout = QVBoxLayout(self)
        self.tabs = QTabWidget()

        # --- Tab 1: Route ---
        self.route_tab = QWidget()
        self.route_layout = QVBoxLayout(self.route_tab)
        self.route_figure = plt.figure()
        self.route_canvas = FigureCanvas(self.route_figure)
        self.route_ax = self.route_figure.add_subplot(111)
        self.route_layout.addWidget(self.route_canvas)

        # --- Tab 2: Fitness ---
        self.fitness_tab = QWidget()
        self.fitness_layout = QVBoxLayout(self.fitness_tab)
        self.fitness_figure = plt.figure()
        self.fitness_canvas = FigureCanvas(self.fitness_figure)
        self.fitness_ax = self.fitness_figure.add_subplot(111)
        self.fitness_layout.addWidget(self.fitness_canvas)

        # Add tabs
        self.tabs.addTab(self.route_tab, "Route")
        self.tabs.addTab(self.fitness_tab, "Fitness")

        self.layout.addWidget(self.tabs)

    def plot_cities(self, cities):
        """Vẽ các điểm thành phố lên biểu đồ Route."""
        self.route_ax.clear()
        self.route_ax.scatter(cities[:, 0], cities[:, 1], c='blue', zorder=2)
        for i, city in enumerate(cities):
            self.route_ax.text(city[0], city[1] + 0.01, str(i), fontsize=12)
        self.route_ax.set_title("City Map")
        self.route_ax.set_xlabel("X")
        self.route_ax.set_ylabel("Y")
        self.route_canvas.draw()

    def plot_route(self, cities, route_indices):
        """Vẽ đường đi nối các thành phố."""
        # Nối điểm cuối về điểm đầu để tạo chu trình
        full_route = list(route_indices) + [route_indices[0]]
        ordered_cities = cities[full_route, :]

        self.route_ax.plot(ordered_cities[:, 0], ordered_cities[:, 1], c='red', linewidth=1.5, zorder=1)
        self.route_canvas.draw()

    def plot_fitness_history(self, history):
        """Vẽ biểu đồ lịch sử fitness."""
        self.fitness_ax.clear()
        self.fitness_ax.plot(history)
        self.fitness_ax.set_title("Fitness over Generations")
        self.fitness_ax.set_xlabel("Generation")
        self.fitness_ax.set_ylabel("Fitness (e.g., 1/Distance)")
        self.fitness_canvas.draw()