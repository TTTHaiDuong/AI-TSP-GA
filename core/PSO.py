import numpy as np

from core.utils import OptimizationResult, time_memory_bench, batch_cost_func
from core.two_opt import two_opt_population


class PSO:
    """Optimized Particle Swarm Optimization for TSP (vectorized version)"""
    
    def __init__(
        self, cost_matrix: np.ndarray, n_particles=30, init_velocity=0.5, 
        w=0.7, c1=1.5, c2=1.5, v_max=0.5
    ):
        self.cost_matrix = cost_matrix.astype(np.float64)
        self.n_cities = cost_matrix.shape[0]
        self.n_particles = n_particles
        self.init_velocity = init_velocity
        self.w, self.c1, self.c2, self.v_max = w, c1, c2, v_max
                
        self.gbest_cost = np.inf
        

    def decode_route(self, positions: np.ndarray):
        """Evaluate all particles' tours at once"""
        if positions.ndim == 1:
            return np.argsort(positions)
        return np.argsort(positions, axis=1)
    

    def evaluate(self):
        self.cost_func_call += self.n_particles
        routes = self.decode_route(self.positions)
        self.pbest_cost = batch_cost_func(self.cost_matrix, routes)

        return self.pbest_cost


    def run(self, iters=100, seed=None):
        self.np_rng = np.random.default_rng(seed)

        self.positions = self.np_rng.random((self.n_particles, self.n_cities))
        self.velocities = self.np_rng.uniform(-self.init_velocity, self.init_velocity, (self.n_particles, self.n_cities))
        self.pbest_positions = self.positions.copy()
        self.pbest_cost = np.full(self.n_particles, np.inf)

        self.cost_func_call = 0
        best_cost_hist = []
        avg_cost_hist = []

        for _ in range(iters):
            costs = self.evaluate()
            
            improved = costs < self.pbest_cost
            self.pbest_positions[improved] = self.positions[improved]
            self.pbest_cost[improved] = costs[improved]

            min_idx = np.argmin(costs)
            if costs[min_idx] < self.gbest_cost:
                self.gbest_cost = costs[min_idx]
                # Vì gbest_cost = np.inf nên gbest_position chắc nhắn được tạo
                self.gbest_position = self.positions[min_idx].copy()

            r1 = self.np_rng.random((self.n_particles, self.n_cities))
            r2 = self.np_rng.random((self.n_particles, self.n_cities))

            cognitive = self.c1 * r1 * (self.pbest_positions - self.positions)
            social = self.c2 * r2 * (self.gbest_position - self.positions) # type: ignore vì gbest_position luôn được tạo ra ở vòng lặp trên

            self.velocities = self.w * self.velocities + cognitive + social
            self.velocities = np.clip(self.velocities, -self.v_max, self.v_max)

            self.positions += self.velocities
            # Chuẩn hoá tránh tràn khỏi [0, 1]
            self.positions = (self.positions - self.positions.min(axis=1, keepdims=True)) / \
                 (self.positions.max(axis=1, keepdims=True) - self.positions.min(axis=1, keepdims=True) + 1e-10)            
            
            avg_cost_hist.append(np.mean(costs))
            best_cost_hist.append(self.gbest_cost)
        
        return {
            "avg_cost_hist": avg_cost_hist,
            "best_cost_hist": [float(x) for x in best_cost_hist],
            "best_cost": self.gbest_cost, 
            "best_route": self.decode_route(self.gbest_position)
        }
    

def run(cost_matrix, n_particles, init_velocity, w, c1, c2, v_max, max_iter, seed) -> OptimizationResult:
    cost_matrix = np.asarray(cost_matrix, dtype=np.float64)
    pso = PSO(cost_matrix, n_particles, init_velocity, w, c1, c2, v_max)

    bench = time_memory_bench(pso.run, max_iter, seed)

    return {
        "avgCostHist": [float(x) for x in bench["result"]["avg_cost_hist"]],
        "bestCost": float(bench["result"]["best_cost"]),
        "bestCostHist": [float(x) for x in bench["result"]["best_cost_hist"]],
        "bestRoute": bench["result"]["best_route"].tolist(),
        "costFuncCall": pso.cost_func_call,
        "memory": bench["memory_diff"],
        "time": bench["time"]
    }