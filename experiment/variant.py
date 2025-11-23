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
    
    # Khởi tạo các thuật toán
    ga = run_GA(dist_matrix, 50, 0.1, 0.03, 1, 3, 0, 100, None)
    ga_two_opt = run_GA(dist_matrix, 50, 0.1, 0.03, 1, 3, 3, 100, None)

    def cost_func_wrap(route):
        return cost_func(dist_matrix, route)
    
    sko_ga = GA_TSP(func=cost_func_wrap, n_dim=dist_matrix.shape[0], size_pop=dist_matrix.shape[0], max_iter=100, prob_mut=0.03)
    sko_ga_run = time_memory_bench(sko_ga.run)

    # Nhãn
    labels = ["Genetic", "Genetic + 2opt", "SKO's Genetic"]

    # Lấy route và best cost history
    ga_1_route = ga["bestRoute"]
    ga_1_cost_hist = ga["bestCostHist"] # type: ignore
    
    ga_2_route = ga_two_opt["bestRoute"]
    ga_2_cost_hist = ga_two_opt["bestCostHist"] # type: ignore
    
    ga_3_route = sko_ga_run["result"][0]
    ga_3_cost_hist  = [h[0] for h in sko_ga.all_history_Y]

    # Trình bày
    # Time
    print("\n" + "=" * 5 + " Time " + "=" * 5)
    print(f"{labels[0]}: {ga['time']:.4f} s")
    print(f"{labels[1]}: {ga_two_opt['time']:.4f} s")
    print(f"{labels[2]}: {sko_ga_run['time']:.4f} s")

    # Best cost
    print("\n" + "=" * 5 + " Best Cost " + "=" * 5)
    print(f"{labels[0]}: {ga['bestCost']:.4f} s")
    print(f"{labels[1]}: {ga_two_opt['bestCost']:.4f} s")
    print(f"{labels[2]}: {float(np.squeeze(sko_ga_run["result"][1])):.4f} s")

    # Route
    plot_route(coords, ga_1_route, labels[0])
    plot_route(coords, ga_2_route, labels[1])
    plot_route(coords, ga_3_route, labels[2])

    # Lịch sử best cost
    plot_convergence([ga_1_cost_hist, ga_2_cost_hist, ga_3_cost_hist], labels)

    plt.show()

