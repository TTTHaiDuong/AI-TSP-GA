"""
Particle Swarm Optimization (PSO) for Traveling Salesman Problem (TSP)
Using Smallest Position Value (SPV) approach for continuous PSO on discrete problem

The SPV approach works by:
1. Each particle has continuous position values (one per city)
2. To get a tour, we sort the position values and use the sorted indices as the tour
3. Smaller position values come first in the tour
"""
import numpy as np
import core.tsp_helper as tsp


class PSO_TSP_Optimized:
    """Optimized Particle Swarm Optimization for TSP (vectorized version)"""
    
    def __init__(
        self, cost_matrix: np.ndarray, n_particles=30, init_velocity=0.5, 
        w=0.7, c1=1.5, c2=1.5, v_max=0.5
    ):
        self.cost_matrix = cost_matrix.astype(np.float64)
        self.n_cities = cost_matrix.shape[0]
        self.n_particles = n_particles
        self.w, self.c1, self.c2, self.v_max = w, c1, c2, v_max
        
        # Initialize swarm collectively
        self.positions = np.random.rand(n_particles, self.n_cities)
        self.velocities = np.random.uniform(-init_velocity, init_velocity, (n_particles, self.n_cities))
        
        # Personal bests
        self.pbest_positions = self.positions.copy()
        self.pbest_fitness = np.full(n_particles, np.inf)
        
        # Global best
        self.gbest_position = None
        self.gbest_fitness = np.inf
        self.best_route = None
        
        # Tracking
        self.fitness_history = []

    def _batch_total_cost(self, positions: np.ndarray):
        """Evaluate all particles' tours at once"""
        routes = np.argsort(positions, axis=1)  # shape (n_particles, n_cities)
        idx_from = routes
        idx_to = np.roll(routes, -1, axis=1)
        costs = self.cost_matrix[idx_from, idx_to]
        return np.sum(costs, axis=1), routes

    def optimize(self, iters=100):
        for _ in range(iters):
            fitness, routes = self._batch_total_cost(self.positions)
            
            improved = fitness < self.pbest_fitness
            self.pbest_positions[improved] = self.positions[improved]
            self.pbest_fitness[improved] = fitness[improved]

            min_idx = np.argmin(fitness)
            if fitness[min_idx] < self.gbest_fitness:
                self.gbest_fitness = fitness[min_idx]
                self.gbest_position = self.positions[min_idx].copy()
                self.best_route = routes[min_idx]

            if self.gbest_position is None: continue

            r1 = np.random.rand(self.n_particles, self.n_cities)
            r2 = np.random.rand(self.n_particles, self.n_cities)

            cognitive = self.c1 * r1 * (self.pbest_positions - self.positions)
            social = self.c2 * r2 * (self.gbest_position - self.positions)

            self.velocities = self.w * self.velocities + cognitive + social
            self.velocities = np.clip(self.velocities, -self.v_max, self.v_max)

            self.positions += self.velocities
            
            self.fitness_history.append(self.gbest_fitness)
        
        return self.gbest_fitness, self.best_route

    def get_fitness_history(self):
        return np.array(self.fitness_history)
    

def tsp_cost_func(positions: np.ndarray) -> np.ndarray:
    """
    positions: shape (n_particles, n_cities)
    Trả về chi phí tổng quãng đường cho mỗi particle
    """
    n_particles = positions.shape[0]
    costs = np.zeros(n_particles)
    for i in range(n_particles):
        tour = np.argsort(positions[i])
        costs[i] = tsp.total_cost(tour.tolist(), cost_matrix)
    return costs


if __name__ == "__main__":
    from pprint import pprint
    import matplotlib.pyplot as plt
    import pyswarms as ps

    n_cities = 10
    np.random.seed(42)
    cost_matrix = np.random.randint(10, 100, size=(n_cities, n_cities)).astype(float)
    np.fill_diagonal(cost_matrix, np.inf)  # không đi chính nó

    print("Cost matrix:")
    pprint(cost_matrix)

    pso = PSO_TSP_Optimized(cost_matrix, n_particles=10, init_velocity=0.5, w=0.7, c1=1.5, c2=1.5)

    options = {'c1': 1.5, 'c2': 1.5, 'w': 0.7}
    bounds = (np.zeros(n_cities), np.ones(n_cities))  # position trong [0,1] để SPV

    optimizer = ps.single.GlobalBestPSO(
        n_particles=10,
        dimensions=n_cities,
        options=options,
        bounds=bounds
    )

    best_cost, best_route = pso.optimize(iters=500)
    # best_cost, best_pos = optimizer.optimize(tsp_cost_func, iters=500); best_route = np.argsort(best_pos).tolist()

    print("\nBest cost (total distance):", best_cost)
    print("Best route (indices):", best_route)
    print("Check total cost:", tsp.total_cost(best_route, cost_matrix))

    # --- Vẽ biểu đồ ---
    coords = np.random.rand(n_cities, 2) * 100  # tọa độ x,y trong khoảng [0,100]

    plt.figure(figsize=(8,6))
    # Vẽ các thành phố
    plt.scatter(coords[:,0], coords[:,1], color='red', s=100, zorder=2)
    for i, (x, y) in enumerate(coords):
        plt.text(x+1, y+1, str(i), fontsize=12, color='blue')

    # Vẽ đường đi tour tốt nhất
    route_coords = coords[best_route + [best_route[0]]]  # quay về điểm xuất phát
    plt.plot(route_coords[:,0], route_coords[:,1], color='green', linewidth=2, marker='o', zorder=1)

    plt.title("PySwarms PSO TSP - Best Tour")
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.grid(True)
    plt.show()