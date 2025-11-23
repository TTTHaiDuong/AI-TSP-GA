import numpy as np
import random

from core.utils import OptimizationResult, time_memory_bench, batch_cost_func
from core.two_opt import two_opt_population


def cal_total_distance(routine, points):
    routine = np.concatenate([routine, [routine[0]]])
    return np.sum(np.linalg.norm(points[routine[:-1]] - points[routine[1:]], axis=1))


def get_neighbor(solution):
    a, b = random.sample(range(len(solution)), 2)
    neighbor = solution.copy()
    neighbor[a], neighbor[b] = neighbor[b], neighbor[a]
    return neighbor


def BCO_TSP(points, n_bees=50, max_iter=200):
    n_cities = len(points)
    
    # Khởi tạo quần thể bee
    bees = [np.random.permutation(n_cities) for _ in range(n_bees)]
    best_bee = min(bees, key=lambda s: cal_total_distance(s, points))
    best_dist = cal_total_distance(best_bee, points)
    
    history = [best_dist]  # lưu giá trị hội tụ
    
    for it in range(max_iter):
        new_bees = []
        for bee in bees:
            neighbor = get_neighbor(bee)
            if cal_total_distance(neighbor, points) < cal_total_distance(bee, points):
                new_bees.append(neighbor)
            else:
                new_bees.append(bee)
        
        # backward pass: chia sẻ thông tin
        bees = sorted(new_bees, key=lambda s: cal_total_distance(s, points))[:n_bees]
        current_best = bees[0]
        current_best_dist = cal_total_distance(current_best, points)
        if current_best_dist < best_dist:
            best_bee = current_best
            best_dist = current_best_dist
        
        history.append(best_dist)
        if it % 20 == 0:
            print(f"Iter {it}: Best distance = {best_dist:.4f}")
    
    return best_bee, best_dist, history
    

def run(points, n_bees=50, max_iter=200) -> OptimizationResult:
    bench = time_memory_bench(BCO_TSP, points, n_bees, max_iter)

    return {
        "bestCost": float(bench["result"][1]),
        "bestCostHist": [float(x) for x in bench["result"][2]],
        "bestRoute": bench["result"][0].tolist(),
        "costFuncCall": 0,
        "memory": bench["memory_diff"],
        "time": bench["time"]
    }