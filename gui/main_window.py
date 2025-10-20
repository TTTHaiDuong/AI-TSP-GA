from PySide6.QtWidgets import QMainWindow, QWidget, QSplitter, QHBoxLayout, QVBoxLayout, QLabel
from PySide6.QtCore import Qt
import numpy as np

from gui.control_panel import ControlPanel
from gui.plot_widgets import PlotTabs


# import core.tsp_solver as tsp # Sẽ import khi có thuật toán

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("AI TSP Solver")
        self.setGeometry(100, 100, 1200, 800)

        # Main layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        main_layout = QHBoxLayout(central_widget)

        # Splitter để chia màn hình
        splitter = QSplitter(Qt.Orientation.Horizontal)

        # Khởi tạo các thành phần
        self.control_panel = ControlPanel()
        self.plot_tabs = PlotTabs()

        # Phần kết quả (đơn giản)
        self.results_panel = QWidget()
        results_layout = QVBoxLayout(self.results_panel)
        results_layout.setAlignment(Qt.AlignmentFlag.AlignTop)
        results_layout.addWidget(QLabel("<b>Results</b>"))
        self.distance_label = QLabel("Calculated Distance: N/A")
        self.highscore_label = QLabel("Topology Highscore: N/A")
        results_layout.addWidget(self.distance_label)
        results_layout.addWidget(self.highscore_label)

        # Sắp xếp layout chính: control panel, splitter (chứa plot và results)
        main_splitter = QSplitter(Qt.Orientation.Horizontal)
        plot_and_results_widget = QWidget()
        plot_and_results_layout = QVBoxLayout(plot_and_results_widget)
        plot_and_results_layout.addWidget(self.plot_tabs)
        plot_and_results_layout.addWidget(self.results_panel)

        main_splitter.addWidget(self.control_panel)
        main_splitter.addWidget(plot_and_results_widget)
        main_splitter.setStretchFactor(0, 1)  # sidebar size
        main_splitter.setStretchFactor(1, 3)  # main content size

        main_layout.addWidget(main_splitter)

        # --- Kết nối Signals và Slots ---
        self.control_panel.solve_button.clicked.connect(self.run_solve_tsp)
        self.control_panel.nodes_slider.valueChanged.connect(self.generate_and_plot_cities)
        self.control_panel.seed_input.valueChanged.connect(self.generate_and_plot_cities)

        # Khởi tạo dữ liệu ban đầu
        self.cities = None
        self.generate_and_plot_cities()

    def generate_and_plot_cities(self):
        """Tạo dữ liệu thành phố mới và vẽ chúng lên bản đồ."""
        seed = self.control_panel.seed_input.value()
        num_nodes = self.control_panel.nodes_slider.value()

        np.random.seed(seed)
        self.cities = np.random.rand(num_nodes, 2)
        self.plot_tabs.plot_cities(self.cities)

    def run_solve_tsp(self):
        """
        Đây là hàm cầu nối giữa GUI và Core.
        Nó sẽ lấy tham số từ control_panel, gọi thuật toán trong core,
        và cập nhật kết quả lên giao diện.
        """
        algorithm = self.control_panel.algorithm_combo.currentText()
        print(f"Running {algorithm}...")

        if self.cities is None:
            return

        # --- PHẦN GIẢ LẬP - Sẽ thay thế bằng thuật toán thật ---
        if algorithm == "Genetic Algorithm":
            # Lấy tham số
            pop_size = self.control_panel.population_input.value()
            generations = self.control_panel.generations_input.value()
            mutation = self.control_panel.mutation_rate_input.value()

            # Giả lập kết quả trả về từ core.tsp_solver.solve_ga(...)
            num_cities = len(self.cities)
            dummy_route = np.random.permutation(num_cities)
            dummy_distance = np.random.uniform(3.5, 4.5)
            dummy_history = 1000 / (np.arange(generations) + pop_size / 10)

            # Cập nhật giao diện
            self.distance_label.setText(f"Calculated Distance: {dummy_distance:.4f}")
            self.highscore_label.setText(f"Topology Highscore: {(1 / dummy_distance):.4f}")
            self.plot_tabs.plot_route(self.cities, dummy_route)
            self.plot_tabs.plot_fitness_history(dummy_history)
        else:
            print("Local Search not yet implemented.")