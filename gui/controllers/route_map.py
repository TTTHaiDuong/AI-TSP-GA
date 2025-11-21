from PySide6.QtCore import QObject, Slot
import numpy as np

class RouteBridge(QObject):

    @Slot(int, int, result=list)
    def randomize(self, n_points, seed=None):
        if seed is not None and seed >= 0: np.random.seed(seed)

        coords = np.random.rand(n_points, 2) * 10
        coords = np.round(coords, decimals=2) 

        result = [{"order": i + 1, "x": float(x), "y": float(y)} for i, (x, y) in enumerate(coords)]
        return result