"""
aco_tsp.py
Robust wrapper for ACO TSP using scikit-opt.

- Thử import ACA_TSP hoặc ACO_TSP tuỳ version của scikit-opt.
- Thêm monkeypatch np.int = int nếu numpy phiên bản mới đã xoá alias.
- Đếm fitness calls bằng wrapped function.
- Đo thời gian (s và µs) và peak memory (tracemalloc).
- Lấy history bằng nhiều fallback attribute names.
- Trả về dict chuẩn tương thích main_comparison.py.
"""

from typing import List, Dict, Any
import time
import tracemalloc
import random
import math
import numpy as np

# ---- Monkeypatch np.int if missing (NumPy >= 1.20 removed np.int alias) ----
# This avoids crashes inside older scikit-opt code that uses np.int.
if not hasattr(np, "int"):
    np.int = int  # safe alias for the running process

# ---- Import ACO class with fallbacks ----
ACO_CLASS = None
try:
    # some scikit-opt versions have ACA in sko.ACA.ACA_TSP
    from sko.ACA import ACA_TSP as _ACO_CLASS  # type: ignore
    ACO_CLASS = _ACO_CLASS
except Exception:
    try:
        # other versions may provide ACO_TSP in sko.ACO
        from sko.ACO import ACO_TSP as _ACO_CLASS  # type: ignore
        ACO_CLASS = _ACO_CLASS
    except Exception:
        ACO_CLASS = None

if ACO_CLASS is None:
    raise ImportError(
        "Could not import ACA_TSP or ACO_TSP from scikit-opt (sko). "
        "Please ensure scikit-opt is installed: pip install scikit-opt"
    )

# --------------------------
# helper: compute tour length using distance matrix
# --------------------------
def tour_length_from_order(order, dist_matrix: List[List[float]]) -> float:
    n = len(order)
    total = 0.0
    for i in range(n):
        a = int(order[i])
        b = int(order[(i + 1) % n])
        total += float(dist_matrix[a][b])
    return total

# --------------------------
# main exported function
# --------------------------
def run_algorithm(dist_matrix: List[List[float]]) -> Dict[str, Any]:
    """
    Run ACO (scikit-opt) on the given distance matrix.
    Returns a result dict compatible with main_comparison.py format.
    """
    n = len(dist_matrix)
    if n < 2:
        raise ValueError("dist_matrix must be at least 2x2.")

    # wrap cost to count fitness calls
    fitness_calls = {"count": 0}
    def wrapped_cost(x):
        fitness_calls["count"] += 1
        return tour_length_from_order(x, dist_matrix)

    # prepare ACO parameters (tunable)
    size_pop = max(4, n)   # number of ants
    max_iter = 120
    alpha = 1.0
    beta = 5.0
    rho = 0.5

    # start tracemalloc + timer
    tracemalloc.start()
    t0 = time.perf_counter_ns()

    # instantiate ACO (class imported earlier as ACO_CLASS)
    # different constructors across versions: many accept func, n_dim/size_pop/max_iter or similar
    # We'll try common parameter names. If constructor fails, raise helpful error.
    try:
        # try common signature (like ACA_TSP(func=..., n_dim=..., size_pop=..., max_iter=...))
        aco = ACO_CLASS(func=wrapped_cost, n_dim=n, size_pop=size_pop, max_iter=max_iter,
                        distance_matrix=dist_matrix, alpha=alpha, beta=beta, rho=rho)
    except TypeError:
        # try alternate signature (some versions use func, x0, ...). We'll fallback to simplest init.
        try:
            aco = ACO_CLASS(func=wrapped_cost, n_dim=n, size_pop=size_pop, max_iter=max_iter)
        except Exception as e:
            tracemalloc.stop()
            raise RuntimeError("Failed to construct ACO class from scikit-opt. "
                               "Constructor signature mismatch.") from e

    # run algorithm
    best_x, best_y = aco.run()

    t1 = time.perf_counter_ns()
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    # try to extract history from possible attribute names
    history = []
    # multiple possible attribute names in different versions:
    candidates = [
        "y_best_history", "best_y_history", "y_best", "best_y", "g_best_y_hist", "g_best_y_history"
    ]
    for attr in candidates:
        if hasattr(aco, attr):
            val = getattr(aco, attr)
            # try to coerce to list of floats
            try:
                history = [float(x) for x in val]
                break
            except Exception:
                # if not iterable of numbers, skip
                pass
    if not history:
        # fallback: single value history
        history = [float(best_y)]

    # ensure best_x is list of ints
    try:
        best_tour = [int(x) for x in best_x]
    except Exception:
        # if it's numpy array:
        best_tour = list(map(int, np.array(best_x).tolist()))

    result = {
        "name": "ACO",
        "n_nodes": n,
        "best_cost": float(best_y),
        "best_tour": best_tour,
        "time": (t1 - t0) / 1e9,
        "time_us": (t1 - t0) / 1e3,
        "fitness_calls": int(fitness_calls["count"]),
        "memory_bytes": int(peak),
        "memory_kb": float(peak) / 1024.0,
        "history": history,
    }

    return result


# Quick test when running file directly
if __name__ == "__main__":
    import numpy as _np
    _np.random.seed(1)
    n_test = 12
    M = _np.random.randint(5, 80, (n_test, n_test)).astype(float)
    _np.fill_diagonal(M, 0.0)


    res = run_algorithm(M.tolist())
    print("ACO run (demo):")
    for k, v in res.items():
        if k == "history":
            print(k, "length =", len(v))
        else:
            print(k, ":", v)
