import numpy as np
from sko.ACA import ACA_TSP
np.int = int # Thư viện sko còn sử dụng API numpy cũ

from core.utils import OptimizationResult, cost_func, time_memory_bench


def run(cost_matrix, size_pop, max_iter, alpha, beta, rho) -> OptimizationResult:
    cost_matrix = np.asarray(cost_matrix, dtype=np.float64)
    
    cost_func_call = 0
    def cost_func_wrap(route):
        nonlocal cost_func_call
        cost_func_call += 1
        return cost_func(cost_matrix, route)
    
    n_cities = cost_matrix.shape[0]

    aco = ACA_TSP(func=cost_func_wrap, n_dim=n_cities, size_pop=size_pop, max_iter=max_iter,
                  distance_matrix=cost_matrix, alpha=alpha, beta=beta, rho=rho)

    bench = time_memory_bench(aco.run)
    
    return {
        "bestCost": float(bench["result"][1]),
        "bestCostHist": aco.y_best_history,
        "bestRoute": [int(x) for x in bench["result"][0]],
        "costFuncCall": cost_func_call,
        "memory": bench["memory_diff"],
        "time": bench["time"]
    }