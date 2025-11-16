"""
heldkarp_tsp.py
Dynamic Programming solution for TSP (Held–Karp).
- Full metrics (time, memory, fitness_calls, history)
- Compatible with main_comparison.py
"""

from typing import List, Dict, Any
import time
import tracemalloc
import math


def run_algorithm(dist_matrix: List[List[float]]) -> Dict[str, Any]:
    """
    Run Held-Karp DP on the given TSP distance matrix.
    Returns a dict compatible with SA / ACO format.
    """
    n = len(dist_matrix)
    if n < 2:
        raise ValueError("dist_matrix must be >= 2x2")

    fitness_calls = {"count": 0}

    # cost helper
    def cost(i, j):
        fitness_calls["count"] += 1
        return dist_matrix[i][j]

    # DP table: dp[(mask, i)] = minimum cost to reach node i with visited mask
    dp = {}
    parent = {}

    # track history for each subset size
    history = []

    # ---------- Start timing and memory ----------
    tracemalloc.start()
    t0 = time.perf_counter_ns()

    # Initialize base cases: start at node 0
    for i in range(1, n):
        dp[(1 << i, i)] = cost(0, i)

    # Iterate through subset sizes
    for subset_size in range(2, n):
        # generate subsets of size subset_size (excluding node 0)
        from itertools import combinations
        for subset in combinations(range(1, n), subset_size):
            mask = 0
            for bit in subset:
                mask |= 1 << bit

            # compute dp[(mask, j)] for all j in subset
            for j in subset:
                prev_mask = mask ^ (1 << j)
                best_cost = math.inf
                best_prev = None

                for k in subset:
                    if k == j:
                        continue
                    candidate = dp[(prev_mask, k)] + cost(k, j)
                    if candidate < best_cost:
                        best_cost = candidate
                        best_prev = k

                dp[(mask, j)] = best_cost
                parent[(mask, j)] = best_prev

        # record best cost among all masks of this size
        current_min = math.inf
        for subset in combinations(range(1, n), subset_size):
            mask = 0
            for bit in subset:
                mask |= 1 << bit
            for j in subset:
                if (mask, j) in dp:
                    current_min = min(current_min, dp[(mask, j)])
        history.append(current_min)

    # ---------- Final step: return to start node 0 ----------
    full_mask = (1 << n) - 1
    best_cost_final = math.inf
    best_end = None

    for j in range(1, n):
        cur = dp[(full_mask ^ 1, j)] + cost(j, 0)
        if cur < best_cost_final:
            best_cost_final = cur
            best_end = j

    # -------- Reconstruct tour --------
    tour = [0] * (n + 1)
    tour[n] = 0
    tour_idx = n - 1
    mask = full_mask ^ 1
    last = best_end

    tour[tour_idx] = last
    tour_idx -= 1

    while mask:
        prev = parent.get((mask, last), None)
        if prev is None:
            break
        mask ^= (1 << last)
        last = prev
        tour[tour_idx] = last
        tour_idx -= 1

    # guarantee valid path
    tour[0] = 0

    # ---------- End timing and memory ----------
    t1 = time.perf_counter_ns()
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    # Add final cost to history
    history.append(best_cost_final)

    result = {
        "name": "Held-Karp",
        "n_nodes": n,
        "best_cost": float(best_cost_final),
        "best_tour": tour,
        "time": (t1 - t0) / 1e9,
        "time_us": (t1 - t0) / 1e3,
        "fitness_calls": int(fitness_calls["count"]),
        "memory_bytes": int(peak),
        "memory_kb": float(peak) / 1024.0,
        "history": history,
    }

    return result


# Test run
if __name__ == "__main__":
    import random
    random.seed(0)
    n = 10
    M = [[0 if i == j else random.randint(5, 50) for j in range(n)] for i in range(n)]


    res = run_algorithm(M)
    print("Held-Karp Test:")
    for k, v in res.items():
        if k == "history":
            print(k, "length =", len(v))
        else:
            print(k, ":", v)
