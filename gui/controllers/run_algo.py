from PySide6.QtCore import QObject, Slot
import numpy as np

from core.GA import run as run_GA
from core.PSO import run as run_PSO
from core.ACO import run as run_ACO
from core.SA import run as run_SA
from core.Held_Karp import run as run_Held_Karp


def distance_matrix_np(points):
    points = np.array(points)
    diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
    dist = np.sqrt(np.sum(diff ** 2, axis=-1))
    return dist


class RunAlgorithmsBridge(QObject):

    @Slot(list, int, float, float, int, int, int, int, result=dict)
    def runGA(self, matrix, pop_size, crossover_rate, mutation_rate, elite_size, tournament_size, generations, seed):
        return run_GA(matrix, pop_size, crossover_rate, mutation_rate, elite_size, tournament_size, generations, seed if seed >= 0 else None)
    
    @Slot(list, int, float, float, float, float, float, int, int, result=dict)
    def runPSO(self, matrix, n_particles, init_velocity, w, c1, c2, v_max, max_iter, seed):
        return run_PSO(matrix, n_particles, init_velocity, w, c1, c2, v_max, max_iter, seed if seed >= 0 else None)

    @Slot(list, int, int, float, float, float, result=dict)
    def runACO(self, matrix, pop_size, max_iter, alpha, beta, rho):
        return run_ACO(matrix, pop_size, max_iter, alpha, beta, rho)
    
    @Slot(list, int, float, int, result=dict)
    def runSA(self, matrix, T_max, T_min, L):
        return run_SA(matrix, T_max, T_min, L)
    
    @Slot(list, result=dict)
    def runHeldKarp(self, matrix):
        return run_Held_Karp(matrix)