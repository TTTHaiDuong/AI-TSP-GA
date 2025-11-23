import numpy as np

from core.utils import OptimizationResult, time_memory_bench, batch_cost_func
from core.two_opt import two_opt_population


class GA:
    def __init__(
        self,
        cost_matrix: np.ndarray,
        population_size: int = 100,
        crossover_rate: float = 0.8,
        mutation_rate: float = 0.02,
        elite_size: int = 1,
        tournament_size: int = 3,
        two_opt_max: int = 5
    ):
        self.cost_matrix = cost_matrix.astype(np.float64)
        self.n_cities = cost_matrix.shape[0]
        self.pop_size = population_size
        self.crossover_rate = crossover_rate
        self.mutation_rate = mutation_rate
        self.elite_size = elite_size
        self.tournament_size = tournament_size
        self.two_opt_max = two_opt_max

        self.population = np.array([])
        self.costs = np.zeros(self.pop_size)

        # Sử dụng để đánh giá
        self.cost_func_call = 0
        self.np_rng = np.random.default_rng()


    def evaluate(self):
        self.cost_func_call += self.pop_size # Chức năng đếm số lần gọi cost function
        self.costs = batch_cost_func(self.cost_matrix, self.population)
        
        return self.costs


    def tournament_selection(self):
        # Tạo ma trận random indices (pop_size x k)
        candidates = self.np_rng.integers(0, self.pop_size, size=(self.pop_size, self.tournament_size))
        # Lấy index cá thể thắng từng tournament
        winner_idx = np.argmin(self.costs[candidates], axis=1)
        winner_idx = candidates[np.arange(self.pop_size), winner_idx]
        return self.population[winner_idx]
    

    def order_crossover(self, parent1, parent2):
        N = self.n_cities
        # Lựa chọn 2 phần tử không trùng lặp trong dãy [0, n)
        # Sắp xếp 2 phần tử này để start < end
        start, end = sorted(self.np_rng.choice(N, 2, replace=False))
        child = np.full(N, -1)
        child[start:end] = parent1[start:end]

        used = np.zeros(N, dtype=bool)
        # Đánh dấu đoạn gen của parent1, để tránh lấp vào
        used[parent1[start:end]] = True

        pos = end
        for city in parent2:
            if not used[city]:
                child[pos] = city
                used[city] = True
                pos = (pos + 1) % N

        return child
    

    def crossover_population(self, selected):
        new_pop = []
        for i in range(0, self.pop_size, 2):
            p1, p2 = selected[i], selected[(i + 1) % self.pop_size]
            if self.np_rng.random() < self.crossover_rate:
                c1 = self.order_crossover(p1, p2)
                c2 = self.order_crossover(p2, p1)
            else:
                c1, c2 = p1.copy(), p2.copy()
            new_pop.extend([c1, c2])
        return np.array(new_pop[:self.pop_size])
    

    # Cải thiện bằng mutate per gene
    def per_gen_mutate(self, population):
        N = self.n_cities
        pop_size = self.pop_size

        # Mask per-gene
        mask = self.np_rng.random((pop_size, N)) < self.mutation_rate

        # Chỉ lấy các cá thể có >=2 True
        valid = np.where(mask.sum(axis=1) >= 2)[0]
        if len(valid) == 0:
            return

        # Chọn 2 vị trí swap cho mỗi cá thể valid
        swap_pos = np.array([self.np_rng.choice(np.where(mask[i])[0], 2, replace=False) for i in valid])

        # Thực hiện swap vectorized
        population[valid, swap_pos[:, 0]], population[valid, swap_pos[:, 1]] = \
            population[valid, swap_pos[:, 1]], population[valid, swap_pos[:, 0]]
        

    def evolve(self):
        if self.elite_size > 0:
            elite_idx = np.argsort(self.costs)[:self.elite_size]
            elite = self.population[elite_idx].copy()
        
        selected = self.tournament_selection()
        offspring = self.crossover_population(selected)
        self.per_gen_mutate(offspring)

        if self.two_opt_max > 0:
            offspring = two_opt_population(offspring, self.cost_matrix, self.two_opt_max)
        
        if self.elite_size > 0:
            offspring[:self.elite_size] = elite

        self.population = offspring
        self.evaluate()


    def best(self):
        idx = np.argmin(self.costs)
        return self.population[idx], self.costs[idx]
    

    def run(self, generations=100, seed=None, verbose=True):
        self.np_rng = np.random.default_rng(seed)
        
        self.population = self.np_rng.permutation(
            np.tile(np.arange(self.n_cities), (self.pop_size, 1))
        )

        best_cost_hist = []
        avg_cost_hist = []
        self.cost_func_call = 0

        for gen in range(generations):
            self.evolve()
            _, best_cost = self.best()
            best_cost_hist.append(best_cost)
            avg_cost = np.mean(self.costs)
            avg_cost_hist.append(avg_cost)
            
            if verbose: 
                print(f"Gen {gen+1:3d} | Best = {best_cost:.3f} | Avg Cost = {avg_cost:.3f}")
        
        best_route, best_cost = self.best()
        return {
            "avg_cost_hist": avg_cost_hist,
            "best_cost_hist": best_cost_hist,
            "best_cost": best_cost,
            "best_route": best_route
        }
    

def run(cost_matrix, pop_size, crossover_rate, mutation_rate, elite_size, tournament_size, two_opt_max, max_iter, seed, verbose=True) -> OptimizationResult:
    cost_matrix = np.asarray(cost_matrix, dtype=np.float64)
    ga = GA(cost_matrix, pop_size, crossover_rate, mutation_rate, elite_size, tournament_size, two_opt_max)

    bench = time_memory_bench(ga.run, max_iter, seed, verbose)

    return {
        "avgCostHist": [float(x) for x in bench["result"]["avg_cost_hist"]],
        "bestCost": float(bench["result"]["best_cost"]),
        "bestCostHist": [float(x) for x in bench["result"]["best_cost_hist"]],
        "bestRoute": bench["result"]["best_route"].tolist(),
        "costFuncCall": ga.cost_func_call,
        "memory": bench["memory_diff"],
        "time": bench["time"]
    }