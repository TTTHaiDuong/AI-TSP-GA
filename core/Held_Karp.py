import math
from itertools import combinations

from core.utils import OptimizationResult, time_memory_bench


class Held_Karp:
    def __init__(self, cost_matrix):
        self.cost_matrix = cost_matrix
        self.cost_matrix_call = 0

    
    def get_cost_matrix(self):
        self.cost_matrix_call += 1
        return self.cost_matrix


    def generate_subsets(self, n, k):
        """Sinh tất cả subset gồm k phần tử của {0,...,n-1} dưới dạng bitmask."""
        for comb in combinations(range(n), k):
            mask = 0
            for c in comb:
                mask |= (1 << c)
            yield mask


    def run(self):
        self.cost_matrix_call = 0
        n = len(self.cost_matrix)

        # dp[(mask, j)] = chi phí ngắn nhất để đi qua tập mask và kết thúc tại j
        dp = {}
        parent = {}

        # Khởi tạo subset với số lượng 2
        for k in range(1, n):
            mask = (1 << 0) | (1 << k)
            dp[(mask, k)] = self.get_cost_matrix()[0][k]
            parent[(mask, k)] = 0

        # Khởi tạo subset với số lượng 3 trở lên
        for subset_size in range(3, n + 1):
            for mask in self.generate_subsets(n, subset_size):

                if not (mask & 1): 
                    continue # Phải có điểm đầu

                for j in range(1, n):
                    if not (mask & (1 << j)):
                        continue # j không nằm trong subset

                    prev_mask = mask ^ (1 << j) # Bỏ j ra khỏi mask
                    best_cost = math.inf
                    best_prev = None

                    for k in range(1, n):
                        if k == j:
                            continue

                        if not (prev_mask & (1 << k)):
                            continue # Kiểm tra k có trong pre_mask không

                        if (prev_mask, k) not in dp:
                            continue

                        cost = dp[(prev_mask, k)] + self.get_cost_matrix()[k][j]

                        if cost < best_cost:
                            best_cost = cost
                            best_prev = k

                    dp[(mask, j)] = best_cost
                    parent[(mask, j)] = best_prev

        # Quay về 0
        full_mask = (1 << n) - 1
        best_cost = math.inf
        last_city = None

        for j in range(1, n):
            if (full_mask, j) not in dp:
                continue

            cost = dp[(full_mask, j)] + self.get_cost_matrix()[j][0]
            if cost < best_cost:
                best_cost = cost
                last_city = j

        # Khôi phục đường đi
        path = [0]
        mask = full_mask
        j = last_city

        while j != 0:
            path.append(j) # type: ignore
            prev = parent[(mask, j)]
            mask = mask ^ (1 << j) # type: ignore
            j = prev

        path.append(0)
        path.reverse()

        return path, best_cost


def run(cost_matrix) -> OptimizationResult:
    held_karp = Held_Karp(cost_matrix)
    bench = time_memory_bench(held_karp.run)
    
    return {
        "bestCost": bench["result"][1],
        "bestRoute": bench["result"][0],
        "costFuncCall": held_karp.cost_matrix_call,
        "time": bench["time"],
        "memory": bench["memory_diff"]
    }