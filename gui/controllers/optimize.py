from PySide6.QtCore import QObject, Signal, Slot
import numpy as np
import psutil, os, time

from core.genetic import GA


def distance_matrix_np(points):
    points = np.array(points)
    diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
    dist = np.sqrt(np.sum(diff ** 2, axis=-1))
    return dist


def normalize_matrix(matrix): 
    normalized = []

    for row in matrix:
        new_row = []

        for cell in row:
            if isinstance(cell, (int, float)):
                new_row.append(cell)

            elif isinstance(cell, dict):
                v = cell.get("dist", 0) + cell.get("weight", 0)
                new_row.append(v)

            else:
                raise ValueError("Kiểu dữ liệu không hợp lệ")

        normalized.append(new_row)

    return normalized


class OptimizationBridge(QObject):
    randomized = Signal(list)

    @Slot(list, int, int, float, float, int, int, int, result=dict)
    def genetic(self, matrix, pop_size, generations, crossover_rate, mutation_rate, elite_size, tournament_size, seed):
        norm_matrix = np.array(normalize_matrix(matrix))
        print(seed)

        ga = GA(norm_matrix, pop_size, crossover_rate, mutation_rate, elite_size, tournament_size)
        
        bench = time_memory_bench(ga.optimize, generations, seed if seed >= 0 else None)
        
        return {
            "avgCostHist": np.array(bench["result"]["avg_cost_hist"]).tolist(), 
            "bestCostHist": np.array(bench["result"]["best_cost_hist"]).tolist(),
            "bestRoute": bench["result"]["best_route"].tolist(), 
            "bestCost": float(bench["result"]["best_cost"]),
            "time": bench["time"],
            "memory": bench["memory_diff"]
        }
    
    @Slot(list, result=list)
    def pso(self, pts, **algo_params):
        pass


def time_memory_bench(func, *params, **dict_params):
    process = psutil.Process(os.getpid())
    start_mem = process.memory_info().rss
    start = time.perf_counter()

    result = func(*params, **dict_params)

    end = time.perf_counter()
    end_mem = process.memory_info().rss

    return {
        "result": result,
        "time": end - start,
        "memory_diff": end_mem - start_mem,
        "memory_total": end_mem
    }