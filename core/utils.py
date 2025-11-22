import time, math
import tracemalloc
import numpy as np
from typing import TypedDict, NotRequired


class OptimizationResult(TypedDict):
    avgCostHist: NotRequired[list[float]]
    bestCost: float
    bestCostHist: NotRequired[list[float]]
    bestRoute: list[int]
    costFuncCall: int
    memory: float
    routeHist: NotRequired[list[int]]
    time: float


def euclid(a, b):
    return math.sqrt((a["x"] - b["x"])**2 + (a["y"] - b["y"])**2)


def batch_cost_func(cost_matrix, routes):
    idx1 = routes[:, :-1] # [[0, 1, 2], [0, 2, 3]]
    idx2 = routes[:, 1:]  # [[1, 2, 3], [2, 3, 4]]

    costs = cost_matrix[idx1, idx2].sum(axis=1) \
        + cost_matrix[routes[:, -1], routes[:, 0]] # Chi phí điểm cuối và điểm đầu     
        
    return costs
    

def cost_func(cost_matrix, route) -> float:
    route = np.asarray(route)
    routes = route[None, :]
    return batch_cost_func(cost_matrix, routes)[0]


def time_memory_bench(func, *params, **dict_params):    
    tracemalloc.start()
    start_time = time.perf_counter()

    result = func(*params, **dict_params)

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    end_time = time.perf_counter()

    return {
        "result": result,
        "time": end_time - start_time,
        "memory_diff": current,
        "memory_total": peak
    }