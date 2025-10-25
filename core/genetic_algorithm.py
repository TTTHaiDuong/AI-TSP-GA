import random
import math
from typing import List, Callable


# ==============================
# LỚP ĐẠI DIỆN MỘT CÁ THỂ
# ==============================
class Individual:
    def __init__(self, genes: List[float]):
        self.genes = genes
        self.fitness = None

    def evaluate(self, fitness_func: Callable):
        self.fitness = fitness_func(self.genes)
        return self.fitness


# ==============================
# LỚP THUẬT TOÁN DI TRUYỀN
# ==============================
class GeneticAlgorithm:
    def __init__(
        self,
        population_size: int,
        gene_length: int,
        fitness_func: Callable,
        crossover_rate: float = 0.8,
        mutation_rate: float = 0.01,
        elitism: bool = True
    ):
        self.population_size = population_size
        self.gene_length = gene_length
        self.fitness_func = fitness_func
        self.crossover_rate = crossover_rate
        self.mutation_rate = mutation_rate
        self.elitism = elitism
        self.population: List[Individual] = []

    # --------------------------------------
    def initialize_population(self):
        self.population = [
            Individual([random.randint(0, 1) for _ in range(self.gene_length)])
            for _ in range(self.population_size)
        ]
        for ind in self.population:
            ind.evaluate(self.fitness_func)

    # --------------------------------------
    def selection(self) -> Individual:
        """Chọn cá thể tốt nhất giữa 2 cá thể ngẫu nhiên (Tournament)"""
        a, b = random.sample(self.population, 2)
        return a if a.fitness > b.fitness else b

    # --------------------------------------
    def crossover(self, p1: Individual, p2: Individual):
        if random.random() > self.crossover_rate:
            return Individual(p1.genes[:]), Individual(p2.genes[:])

        point = random.randint(1, self.gene_length - 1)
        child1_genes = p1.genes[:point] + p2.genes[point:]
        child2_genes = p2.genes[:point] + p1.genes[point:]
        return Individual(child1_genes), Individual(child2_genes)

    # --------------------------------------
    def mutate(self, individual: Individual):
        for i in range(len(individual.genes)):
            if random.random() < self.mutation_rate:
                individual.genes[i] = 1 - individual.genes[i]

    # --------------------------------------
    def evolve(self):
        new_population = []
        if self.elitism:
            elite = max(self.population, key=lambda ind: ind.fitness)
            new_population.append(Individual(elite.genes[:]))
            new_population[0].fitness = elite.fitness

        while len(new_population) < self.population_size:
            parent1 = self.selection()
            parent2 = self.selection()
            child1, child2 = self.crossover(parent1, parent2)
            self.mutate(child1)
            self.mutate(child2)
            child1.evaluate(self.fitness_func)
            child2.evaluate(self.fitness_func)
            new_population.extend([child1, child2])

        self.population = new_population[:self.population_size]

    # --------------------------------------
    def best_individual(self) -> Individual:
        return max(self.population, key=lambda ind: ind.fitness)

    # --------------------------------------
    def run(self, generations: int):
        for gen in range(generations):
            self.evolve()
            best = self.best_individual()
            avg_fit = sum(ind.fitness for ind in self.population) / self.population_size
            print(f"Gen {gen+1:3d} | Best = {best.fitness:.3f} | Avg = {avg_fit:.3f}")


# ==============================
# HÀM FITNESS MẪU (OneMax)
# ==============================
def fitness_onemax(genes: List[int]):
    """Đếm số bit 1"""
    return sum(genes)


# ==============================
# DEMO CHẠY THỬ
# ==============================
if __name__ == "__main__":
    ga = GeneticAlgorithm(
        population_size=50,
        gene_length=30,
        fitness_func=fitness_onemax,
        crossover_rate=0.8,
        mutation_rate=0.02
    )
    ga.initialize_population()
    ga.run(generations=50)
    best = ga.best_individual()
    print("Best individual:", best.genes)
    print("Fitness:", best.fitness)
