import numpy as np
from sko.SA import SA_TSP
np.int = int # Thư viện sko còn sử dụng API numpy cũ

from core.utils import OptimizationResult, cost_func, time_memory_bench


def run(cost_matrix: np.ndarray, T_max, T_min, L) -> OptimizationResult:
    cost_matrix = np.asarray(cost_matrix, dtype=np.float64)

    cost_func_call = 0
    def cost_func_wrap(route):
        nonlocal cost_func_call
        cost_func_call += 1
        return cost_func(cost_matrix, route)
    
    n_cities = cost_matrix.shape[0]
    x0 = np.random.permutation(n_cities)

    sa = SA_TSP(func=cost_func_wrap, x0=x0, T_max=T_max, T_min=T_min, L=L)
    
    bench = time_memory_bench(sa.run)

    return {
        "bestCost": bench["result"][1],
        "bestCostHist": sa.best_y_history,
        "bestRoute": bench["result"][0],
        "costFuncCall": cost_func_call,
        "memory": bench["memory_diff"],
        "time": bench["time"]
    }