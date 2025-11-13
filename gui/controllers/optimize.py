from PySide6.QtCore import QObject, Signal, Slot
import numpy as np

from core.genetic import GA


def distance_matrix_np(points):
    points = np.array(points)
    diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
    dist = np.sqrt(np.sum(diff ** 2, axis=-1))
    return dist


class OptimizationBridge(QObject):
    randomized = Signal(list)

    @Slot(list, int, int, float, float, result=tuple)
    def genetic(self, points, pop_size, generations, crossover_rate, mutation_rate):
        city_list = [(float(c["x"]), float(c["y"])) for c in points]
        cost_matrix = distance_matrix_np(city_list)
        ga = GA(cost_matrix, pop_size, crossover_rate, mutation_rate)
        individual, _ = ga.optimize(generations)
        return individual.tolist(), ga.history
    
    @Slot(list, result=list)
    def solve_tsp(self, pts, **algo_params):
        pass