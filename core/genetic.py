# Sử dụng numpy cho tối ưu thời gian
# Thay vì sử dụng vòng lặp for thì vector hoá vòng lặp bằng numpy
# 
import numpy as np

class GA:
    def __init__(
        self,
        cost_matrix: np.ndarray,
        population_size: int = 100,
        crossover_rate: float = 0.8,
        mutation_rate: float = 0.02,
        elitism: bool = True
    ):
        self.cost_matrix = cost_matrix.astype(np.float64)
        self.n_cities = cost_matrix.shape[0]
        self.pop_size = population_size
        self.crossover_rate = crossover_rate
        self.mutation_rate = mutation_rate
        self.elitism = elitism

        self.population = np.array(
            [np.random.permutation(self.n_cities) for _ in range(self.pop_size)]
        )
        self.fitness = np.zeros(self.pop_size)
        self.costs = np.zeros(self.pop_size)

    def evaluate(self):
        """Vectorized fitness computation based on cost matrix"""
        a = self.population
        b = np.roll(self.population, -1, axis=1)
        self.costs = self.cost_matrix[a, b].sum(axis=1)
        self.fitness = 1.0 / (self.costs + 1e-9)
        return self.fitness
    
    def selection(self):
        """Tournament selection vectorized"""
        idx1 = np.random.randint(0, self.pop_size, self.pop_size)
        idx2 = np.random.randint(0, self.pop_size, self.pop_size)
        better = np.where(self.fitness[idx1] > self.fitness[idx2], idx1, idx2)
        return self.population[better]
    
    def order_crossover(self, parent1, parent2):
        """Order Crossover (OX) cho 1 cặp cha mẹ"""
        n = self.n_cities
        start, end = sorted(np.random.choice(n, 2, replace=False))
        child = np.full(n, -1)
        child[start:end] = parent1[start:end]

        used = np.zeros(n, dtype=bool)
        used[parent1[start:end]] = True

        pos = end
        for city in parent2:
            if not used[city]:
                child[pos] = city
                used[city] = True
                pos = (pos + 1) % n

        return child
    
    def crossover_population(self, selected):
        """Crossover toàn bộ quần thể"""
        new_pop = []
        for i in range(0, self.pop_size, 2):
            p1, p2 = selected[i], selected[(i + 1) % self.pop_size]
            if np.random.rand() < self.crossover_rate:
                c1 = self.order_crossover(p1, p2)
                c2 = self.order_crossover(p2, p1)
            else:
                c1, c2 = p1.copy(), p2.copy()
            new_pop.extend([c1, c2])
        return np.array(new_pop[:self.pop_size])
    
    def mutate(self, population):
        """Swap mutation vectorized"""
        n = self.n_cities
        for i in range(self.pop_size):
            if np.random.rand() < self.mutation_rate:
                a, b = np.random.choice(n, 2, replace=False)
                population[i, [a, b]] = population[i, [b, a]]

    def evolve(self):
        """Một vòng tiến hóa"""
        # Selection -> Crossover -> Mutation
        selected = self.selection()
        offspring = self.crossover_population(selected)
        self.mutate(offspring)

        self.population = offspring
        fitness = self.evaluate()
        
        # Elitism
        if self.elitism:
            elite_idx = np.argmax(fitness)
            elite = self.population[elite_idx].copy()
            worst_idx = np.argmin(fitness)
            self.population[worst_idx] = elite
            self.evaluate()


    def best(self):
        idx = np.argmax(self.fitness)
        return self.population[idx], self.costs[idx]
    
    def optimize(self, generations=100):
        for gen in range(generations):
            self.evolve()
            _, best_dist = self.best()
            avg_fit = np.mean(self.fitness)
            print(f"Gen {gen+1:3d} | Best = {best_dist:.3f} | Avg Fit = {avg_fit:.6f}")
        return self.best()
    

if __name__ == "__main__":
    np.random.seed(42)

    # Tạo ma trận chi phí ngẫu nhiên (đối xứng)
    n = 10
    coords = np.random.rand(n, 2) * 100
    cost_matrix = np.sqrt(((coords[:, None, :] - coords[None, :, :]) ** 2).sum(axis=2))
    np.fill_diagonal(cost_matrix, np.inf)

    ga = GA(cost_matrix, population_size=100, mutation_rate=0.03)
    best_route, best_distance = ga.optimize(generations=500)

    print("\nBest route:", best_route)
    print("Best distance:", best_distance)

    import matplotlib.pyplot as plt

    route_coords = coords[np.append(best_route, best_route[0])]

    # Vẽ các thành phố
    plt.figure(figsize=(8, 6))
    plt.scatter(coords[:, 0], coords[:, 1], c='red', s=100, label='Cities')

    # Vẽ đường đi
    plt.plot(route_coords[:, 0], route_coords[:, 1], c='blue', linewidth=2, label='Route')

    # Ghi nhãn thành phố
    for i, (x, y) in enumerate(coords):
        plt.text(x + 1, y + 1, str(i), fontsize=12)

    plt.title(f'Best TSP Route (Distance: {best_distance:.2f})')
    plt.xlabel('X coordinate')
    plt.ylabel('Y coordinate')
    plt.legend()
    plt.grid(True)
    plt.show()