import psutil, os, time, math
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