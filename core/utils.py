import psutil, os, time, math
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


def cost_func(cost_matrix, route) -> float:
    route = np.asarray(route)
    next = np.roll(route, -1)
    return cost_matrix[route, next].sum()



# process = psutil.Process(os.getpid())

def time_memory_bench(func, *params, **dict_params):    
    # ram_before = process.memory_info().rss
    tracemalloc.start()
    start_time = time.perf_counter()

    result = func(*params, **dict_params)

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    end_time = time.perf_counter()
    # ram_after = process.memory_info().rss

    return {
        "result": result,
        "time": end_time - start_time,
        "memory_diff": current,
        "memory_total": peak
    }