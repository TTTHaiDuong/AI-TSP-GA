from typing import List, Dict, Any
import time
import tracemalloc
import random
import math

# scikit-opt SA_TSP
from sko.SA import SA_TSP
import numpy as np

# -------------------------
# Configuration (tuneable)
# -------------------------
DEFAULT_T_MAX = 100.0
DEFAULT_T_MIN = 1.0
L_FACTOR = 10   # inner loop length = L_FACTOR * n
SEED = None     # if you want reproducible behavior set to int

# -------------------------
# Helper: compute cost from order using distance matrix
# -------------------------
def total_distance_from_order(order, D: List[List[float]]) -> float:
    """Compute tour length for permutation 'order' using distance matrix D."""
    n = len(order)
    # ensure we have ints
    ord_int = [int(x) for x in order]
    cost = 0.0
    for i in range(n):
        a = ord_int[i]
        b = ord_int[(i + 1) % n]
        cost += D[a][b]
    return float(cost)

# -------------------------
# Main run function (exported)
# -------------------------
def run_algorithm(dist_matrix: List[List[float]]) -> Dict[str, Any]:
    """
    Run SA_TSP (scikit-opt) on given distance matrix.
    dist_matrix: symmetric NxN list of floats.

    Returns a result dict (see module docstring).
    """
    if SEED is not None:
        random.seed(SEED)
        np_random = np.random.default_rng(SEED)
    else:
        np_random = np.random.default_rng()

    # Validate distance matrix
    if dist_matrix is None:
        raise ValueError("dist_matrix must be provided (NxN list).")
    n = len(dist_matrix)
    if n < 2:
        raise ValueError("Need at least 2 cities.")

    # ******************************
    # Wrap cost function to count calls
    # ******************************
    fitness_calls = {"count": 0}

    def wrapped_cost(x):
        # x will be a permutation-like array/list
        fitness_calls["count"] += 1
        return total_distance_from_order(x, dist_matrix)

    # Prepare x0 (initial order)
    x0 = list(range(n))

    # SA parameters
    T_max = DEFAULT_T_MAX
    T_min = DEFAULT_T_MIN
    L = max(1, L_FACTOR * n)

    # Start memory tracing and timing
    tracemalloc.start()
    t0_ns = time.perf_counter_ns()

    # Construct SA_TSP instance
    sa = SA_TSP(func=wrapped_cost, x0=x0, T_max=T_max, T_min=T_min, L=L)

    # Run algorithm
    best_x, best_y = sa.run()

    t1_ns = time.perf_counter_ns()
    runtime_us = (t1_ns - t0_ns) / 1000.0
    runtime_s = (t1_ns - t0_ns) / 1_000_000_000.0

    # Memory snapshot
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    # Extract history from SA object (robustly)
    history = []
    if hasattr(sa, "best_y_history") and sa.best_y_history is not None:
        # scikit-opt usually stores list of best_y over iterations
        history = list(sa.best_y_history)
    elif hasattr(sa, "best_y") and isinstance(sa.best_y, (list, tuple)):
        # fallback
        try:
            history = list(sa.best_y)
        except Exception:
            history = []
    else:
        # final fallback: use best_y as single-element history
        history = [float(best_y)]

    # Ensure best_x is a list of ints
    best_tour = [int(int(x)) for x in best_x]

    result = {
        "name": "SA",
        "n_nodes": n,
        "best_cost": float(best_y),
        "best_tour": best_tour,
        "time": float(runtime_s),
        "time_us": float(runtime_us),
        "fitness_calls": int(fitness_calls["count"]),
        "memory_bytes": int(peak),
        "memory_kb": float(peak) / 1024.0,
        "history": history
    }

    return result


# -------------------------
# Quick CLI test when run directly
# -------------------------
if __name__ == "__main__":
    # quick demo: random cities -> compute dist matrix -> run SA
    import random
    random.seed(123)
    n = random.randint(10, 20)
    coords = [(random.random() * 100.0, random.random() * 100.0) for _ in range(n)]
    D = [[0.0]*n for _ in range(n)]
    for i in range(n):
        for j in range(i+1, n):
            d = math.hypot(coords[i][0]-coords[j][0], coords[i][1]-coords[j][1])
            D[i][j] = D[j][i] = d

    res = run_algorithm(D)
    print("SA (scikit-opt) demo result:")
    print(f"n = {res['n_nodes']} nodes")
    print(f"best_cost = {res['best_cost']:.6f}")
    print(f"best_tour (len) = {len(res['best_tour'])}")
    print(f"time = {res['time']:.6f} s ({res['time_us']:.3f} µs)")
    print(f"fitness_calls = {res['fitness_calls']}")
    print(f"memory_peak = {res['memory_kb']:.3f} KB ({res['memory_bytes']} bytes)")
    print(f"history length = {len(res['history'])}")