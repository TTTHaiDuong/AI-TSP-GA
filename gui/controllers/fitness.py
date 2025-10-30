# gui/controllers/fitness.py
from PySide6.QtCore import QObject, Signal, Slot, QPointF, QThread
import random
import time

# Import class GeneticAlgorithm từ file bạn đã tạo
from core.genetic_algorithm import GeneticAlgorithm


# =============================================================================
# Lớp Worker: Chạy GA trong một luồng riêng để không làm treo UI
# =============================================================================
class GAWorker(QObject):
    # Signal để gửi tiến trình: (thế hệ hiện tại, fitness tốt nhất)
    progressUpdated = Signal(int, float)
    # Signal để gửi kết quả cuối cùng: (list lộ trình tốt nhất, list các thành phố)
    finished = Signal(list, list)

    def __init__(self, cities, params):
        super().__init__()
        self.cities = cities
        self.params = params
        self.is_running = True

    @Slot()
    def run(self):
        """Hàm này sẽ được thực thi trong luồng riêng."""
        try:
            ga = GeneticAlgorithm(
                cities=self.cities,
                population_size=self.params.get("populationSize", 100),
                mutation_rate=self.params.get("mutationRate", 0.01),
                crossover_rate=self.params.get("crossoverRate", 0.9),
                elitism_count=2  # Giả sử elitism là 2
            )

            num_generations = self.params.get("generations", 500)

            for i in range(num_generations):
                if not self.is_running:
                    break

                best_chromosome, best_fitness = ga.evolve()

                # Gửi tín hiệu cập nhật tiến trình sau mỗi 1 thế hệ
                self.progressUpdated.emit(i + 1, best_fitness)

                # Có thể thêm một khoảng nghỉ nhỏ để UI "thở"
                # QThread.msleep(10)

            # Gửi kết quả cuối cùng khi vòng lặp kết thúc
            self.finished.emit(best_chromosome, self.cities)
        except Exception as e:
            print(f"Lỗi trong GAWorker: {e}")

    def stop(self):
        self.is_running = False


# =============================================================================
# Lớp Controller: Cầu nối chính giữa Python và QML
# =============================================================================
class AppController(QObject):
    # Tín hiệu để cập nhật biểu đồ fitness
    updateFitnessChart = Signal(QPointF)
    # Tín hiệu để vẽ các thành phố lên bản đồ
    drawNodesOnMap = Signal("QVariantList")  # QVariantList tương ứng list trong Python
    # Tín hiệu để vẽ lộ trình tốt nhất
    drawRouteOnMap = Signal("QVariantList")
    # Tín hiệu để xóa các biểu đồ cũ
    clearCharts = Signal()

    def __init__(self):
        super().__init__()
        self.ga_thread = None
        self.ga_worker = None
        self.cities = []

    @Slot(int, int)
    def generate_cities(self, num_nodes, seed):
        """Tạo ra danh sách các thành phố ngẫu nhiên."""
        print(f"Generating {num_nodes} cities with seed {seed}...")
        random.seed(seed)
        # Tạo tọa độ trong khoảng (0, 100)
        self.cities = [{"x": random.randint(0, 100), "y": random.randint(0, 100)} for _ in range(num_nodes)]

        # Xóa biểu đồ cũ và vẽ các điểm thành phố mới
        self.clearCharts.emit()
        self.drawNodesOnMap.emit(self.cities)

    @Slot("QVariantMap")  # QVariantMap tương ứng dict trong Python
    def run_ga(self, params):
        """Khởi động thuật toán GA trong một luồng mới."""
        if not self.cities:
            print("Chưa có thành phố nào được tạo. Hãy nhấn 'Generate' trước.")
            return

        print(f"Running GA with params: {params}")

        # Dừng luồng cũ nếu đang chạy
        if self.ga_thread and self.ga_thread.isRunning():
            self.ga_worker.stop()
            self.ga_thread.quit()
            self.ga_thread.wait()

        # Xóa biểu đồ fitness cũ
        self.clearCharts.emit()
        self.drawNodesOnMap.emit(self.cities)  # Vẽ lại các node

        # 1. Tạo Thread và Worker
        self.ga_thread = QThread()
        # Chuyển đổi list of dicts thành list of tuples cho thuật toán GA
        city_tuples = [(city['x'], city['y']) for city in self.cities]
        self.ga_worker = GAWorker(city_tuples, params)
        self.ga_worker.moveToThread(self.ga_thread)

        # 2. Kết nối signals từ worker tới slots trong controller
        self.ga_thread.started.connect(self.ga_worker.run)
        self.ga_worker.finished.connect(self.on_ga_finished)
        self.ga_worker.progressUpdated.connect(self.on_ga_progress)

        # Dọn dẹp khi thread kết thúc
        self.ga_worker.finished.connect(self.ga_thread.quit)
        self.ga_worker.finished.connect(self.ga_worker.deleteLater)
        self.ga_thread.finished.connect(self.ga_thread.deleteLater)

        # 3. Bắt đầu luồng
        self.ga_thread.start()

    @Slot(int, float)
    def on_ga_progress(self, generation, fitness):
        """Nhận tín hiệu tiến trình và cập nhật biểu đồ fitness."""
        # print(f"Generation: {generation}, Fitness: {fitness}")
        point = QPointF(generation, fitness)
        self.updateFitnessChart.emit(point)

    @Slot(list, list)
    def on_ga_finished(self, best_route, cities):
        """Nhận tín hiệu kết thúc và vẽ lộ trình tốt nhất."""
        print("GA finished!")

        # Sắp xếp lại danh sách thành phố theo thứ tự của lộ trình tốt nhất
        ordered_cities = [cities[i] for i in best_route]
        # Chuyển đổi thành list of dicts để gửi sang QML
        route_for_qml = [{"x": city[0], "y": city[1]} for city in ordered_cities]

        self.drawRouteOnMap.emit(route_for_qml)