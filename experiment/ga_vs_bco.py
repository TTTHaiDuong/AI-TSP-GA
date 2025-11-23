import numpy as np
import matplotlib.pyplot as plt

from core.GA import run as run_GA
from core.BCO import run as run_BCO
from core.utils import time_memory_bench
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
    
    # Khởi tạo các thuật toán
    ga = run_GA(dist_matrix, 50, 0.1, 0.03, 1, 3, 0, 100, None)
    bco = run_BCO(coords, 50, 100)

    # Nhãn
    labels = ["Genetic", "BCO"]

    # Lấy route và best cost history
    ga_route = ga["bestRoute"]
    bco_route = bco["bestRoute"]
    
    ga_cost_hist = ga["bestCostHist"] # type: ignore
    bco_cost_hist = bco["bestCostHist"] # type: ignore
    
    # Trình bày
    # Time
    print("\n" + "=" * 5 + " Time " + "=" * 5)
    print(f"{labels[0]}: {ga['time']:.4f} s")
    print(f"{labels[1]}: {bco['time']:.4f} s")

    # Best cost
    print("\n" + "=" * 5 + " Best Cost " + "=" * 5)
    print(f"{labels[0]}: {ga['bestCost']:.4f} s")
    print(f"{labels[1]}: {bco['bestCost']:.4f} s")

    # Route
    plot_route(coords, ga_route, labels[0])
    plot_route(coords, bco_route, labels[1])

    # Lịch sử best cost
    plot_convergence([ga_cost_hist, bco_cost_hist], labels)

    plt.show()

