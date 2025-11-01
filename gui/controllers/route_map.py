from PySide6.QtCore import QObject, Signal, Slot, QPointF
import numpy as np

class RouteBridge(QObject):
    # Tín hiệu gửi list điểm (dạng [{x:..., y:...}, ...]) sang QML
    randomized = Signal(list)

    @Slot(int, int, result=list)
    def randomize(self, n_points, seed=None):
        if seed: np.random.seed(seed)

        coords = np.random.rand(n_points, 2).tolist()
        coords = np.round(coords, decimals=2)

        result = [{"x": float(x), "y": float(y)} for x, y in coords]
        return result
    
    @Slot(list, result=list)
    def solve_tsp(self, pts, **algo_params):
        pass