from PySide6.QtCore import QObject, Slot
import numpy as np


class RouteBridge(QObject):

    @Slot(int, int, result=list)
    def randomize(self, n_points, seed):
        np_rng = np.random.default_rng(seed if seed >= 0 else None)

        coords = np_rng.random((n_points, 2)) * 10
        coords = np.round(coords, decimals=2) 

        result = [{"order": i + 1, "x": float(x), "y": float(y)} for i, (x, y) in enumerate(coords)]
        return result