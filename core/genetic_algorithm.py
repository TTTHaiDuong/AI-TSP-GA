import random
import math
from typing import List, Tuple


# =========================================
# LỚP ĐẠI DIỆN CHO MỘT CÁ THỂ (TUYẾN ĐI)
# =========================================
class Individual:
    def __init__(self, route: List[int]):
        self.route = route[:]  # thứ tự các thành phố
        self.fitness = None
        self.distance = None

    def evaluate(self, cities: List[Tuple[float, float]]):
        """Tính tổng quãng đường và fitness"""
        total_distance = 0.0
        for i in range(len(self.route)):
            city_a = cities[self.route[i]]
            city_b = cities[self.route[(i + 1) % len(self.route)]]  # quay lại điểm đầu
            total_distance += math.dist(city_a, city_b)

        self.distance = total_distance
        self.fitness = 1 / total_distance  # fitness càng lớn càng tốt
        return self.fitness


# =========================================
# CROSSOVER: Order Crossover (OX)
# =========================================
def order_crossover(parent1: Individual, parent2: Individual):
    n = len(parent1.route)
    start, end = sorted(random.sample(range(n), 2))

    # Child 1
    child1 = [None] * n
    child1[start:end] = parent1.route[start:end]
    pos = end
    for city in parent2.route:
        if city not in child1:
            if pos >= n:
                pos = 0
            child1[pos] = city
            pos += 1

    # Child 2
    child2 = [None] * n
    child2[start:end] = parent2.route[start:end]
    pos = end
    for city in parent1.route:
        if city not in child2:
            if pos >= n:
                pos = 0
            child2[pos] = city
            pos += 1

    return Individual(child1), Individual(child2)


# =========================================
# ĐỘT BIẾN: hoán đổi vị trí 2 thành phố (swap)
# =========================================
def swap_mutation(individual: Individual, mutation_rate: float):
    for i in range(len(individual.route)):
        if random.random() < mutation_rate:
            j = random.randint(0, len(individual.route) - 1)
            individual.route[i], individual.route[j] = individual.route[j], individual.route[i]


# =========================================
# LỚP THUẬT TOÁN DI TRUYỀN CHO TSP
# =========================================
class GeneticAlgorithmTSP:
    def __init__(
        self,
        cities: List[Tuple[float, float]],
        population_size: int = 100,
        crossover_rate: float = 0.8,
        mutation_rate: float = 0.02,
        elitism: bool = True
    ):
        self.cities = cities
        self.num_cities = len(cities)
        self.population_size = population_size
        self.crossover_rate = crossover_rate
        self.mutation_rate = mutation_rate
        self.elitism = elitism
        self.population: List[Individual] = []

    # -----------------------------------------
    def initialize_population(self):
        """Khởi tạo quần thể ngẫu nhiên (mỗi route là 1 hoán vị duy nhất)"""
        base_route = list(range(self.num_cities))
        self.population = []
        for _ in range(self.population_size):
            route = base_route[:]
            random.shuffle(route)
            ind = Individual(route)
            ind.evaluate(self.cities)
            self.population.append(ind)

    # -----------------------------------------
    def selection(self) -> Individual:
        """Chọn cá thể tốt nhất giữa 2 cá thể ngẫu nhiên"""
        a, b = random.sample(self.population, 2)
        return a if a.fitness > b.fitness else b

    # -----------------------------------------
    def evolve(self):
        new_population = []

        # Giữ cá thể tốt nhất (elitism)
        if self.elitism:
            elite = max(self.population, key=lambda ind: ind.fitness)
            new_population.append(Individual(elite.route))
            new_population[0].evaluate(self.cities)

        while len(new_population) < self.population_size:
            parent1 = self.selection()
            parent2 = self.selection()

            if random.random() < self.crossover_rate:
                child1, child2 = order_crossover(parent1, parent2)
            else:
                child1, child2 = Individual(parent1.route[:]), Individual(parent2.route[:])

            swap_mutation(child1, self.mutation_rate)
            swap_mutation(child2, self.mutation_rate)

            child1.evaluate(self.cities)
            child2.evaluate(self.cities)

            new_population.extend([child1, child2])

        self.population = new_population[:self.population_size]

    # -----------------------------------------
    def best_individual(self) -> Individual:
        return max(self.population, key=lambda ind: ind.fitness)

    # -----------------------------------------
    def run(self, generations: int = 100):
        for gen in range(generations):
            self.evolve()
            best = self.best_individual()
            avg_fit = sum(ind.fitness for ind in self.population) / len(self.population)
            print(f"Gen {gen+1:3d} | Best distance = {best.distance:.3f} | Avg fit = {avg_fit:.5f}")
        return self.best_individual()


# =========================================
# DEMO CHẠY THỬ
# =========================================
if __name__ == "__main__":
    print("=== DEMO Genetic Algorithm cho Travelling Salesman Problem (TSP) ===\n")

    # Tạo 10 thành phố ngẫu nhiên (tọa độ x, y)
    random.seed(42)
    cities = [(random.uniform(0, 100), random.uniform(0, 100)) for _ in range(10)]

    ga = GeneticAlgorithmTSP(
        cities=cities,
        population_size=100,
        crossover_rate=0.9,
        mutation_rate=0.02,
        elitism=True
    )

    ga.initialize_population()
    best = ga.run(generations=150)

    print("\nBest route found:")
    print(best.route)
    print("Total distance:", best.distance)
