import numpy as np
import matplotlib.pyplot as plt

from core.GA import run as run_GA
from sko.GA import GA_TSP
from core.utils import time_memory_bench, cost_func
from experiment.plot import plot_route, plot_convergence


def euclidean_distance_matrix(coords):
    n = len(coords)
    dist_matrix = np.zeros((n, n))
    for i in range(n):
        for j in range(i+1, n):
            dist = np.linalg.norm(coords[i] - coords[j])
            dist_matrix[i, j] = dist
            dist_matrix[j, i] = dist  # đối xứng
    return dist_matrix


if __name__ == "__main__":
    # Đầu vào bài toán
    coords = np.array([
        [10, 10],
        [20, 30],
        [15, 5],
        [40, 20],
        [25, 25],
        [30, 10],
        [50, 30],
        [55, 15],
        [35, 35],
        [45, 5],
        [60, 20],
        [65, 25],
        [70, 10],
        [20, 50],
        [10, 40],
        [5, 25],
        [35, 45],
        [50, 50],
        [55, 40],
        [60, 35]
    ])

    dist_matrix = euclidean_distance_matrix(coords)

    N = 10

    mutation_range = [0.01, 0.05]
    mutation_converg = []
    for i in range(N):
        mutation_rate = mutation_range[0] + i * (mutation_range[1] - mutation_range[0]) / (N - 1)
        ga = run_GA(dist_matrix, 50, 0.1, mutation_rate, 1, 3, 0, 100, None, False)
        mutation_converg.append(ga["bestCost"])

    crossover_range = [0.5, 0.9]
    crossover_converg = []
    for i in range(N):
        crossover_rate = crossover_range[0] + i * (crossover_range[1] - crossover_range[0]) / (N - 1)
        ga = run_GA(dist_matrix, 50, crossover_rate, 0.03, 1, 3, 0, 100, None, False)
        crossover_converg.append(ga["bestCost"])
        
    # Nhãn
    labels = ["Mutation", "Crossover"]
    plot_convergence([mutation_converg, crossover_converg], labels)
    plt.show()