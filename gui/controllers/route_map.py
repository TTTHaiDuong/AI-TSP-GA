from PySide6.QtCore import QObject, Signal, Slot, QPointF
import numpy as np

from core.pso_continuous import solve_tsp_pso, PSO
from core.pso_discrete import solve_tsp_discrete_pso, DiscretePSO


class RouteBridge(QObject):
    # Tín hiệu gửi list điểm (dạng [{x:..., y:...}, ...]) sang QML
    randomized = Signal(list)
    # Tín hiệu gửi kết quả giải thuật
    solutionFound = Signal(list, float)  # tour, distance
    fitnessUpdated = Signal(list)  # fitness history

    @Slot(int, int, result=list)
    def randomize(self, n_points, seed=None):
        if seed: np.random.seed(seed)

        coords = np.random.rand(n_points, 2).tolist()
        coords = np.round(coords, decimals=2)

        result = [{"x": float(x), "y": float(y)} for x, y in coords]
        return result
    
    @Slot(list, str, int, float, float, float, float, float, int, result=list)
    def solve_tsp_pso(self, cities, algorithm="PSO", swarm_size=30, 
                      initial_velocity=0.5, inertia_weight=0.7, 
                      cognitive_coef=1.5, social_coef=1.5, 
                      velocity_clamping=1.0, max_iterations=100):
        """
        Solve TSP using PSO algorithm
        
        Args:
            cities: List of city coordinates [{"x": x1, "y": y1}, ...]
            algorithm: Algorithm name (for future extension)
            swarm_size: Number of particles in swarm
            initial_velocity: Initial velocity magnitude
            inertia_weight: Inertia weight (w)
            cognitive_coef: Cognitive coefficient (c1)
            social_coef: Social coefficient (c2)
            velocity_clamping: Maximum velocity (0 for no clamping)
            max_iterations: Number of iterations
            
        Returns:
            List of city indices representing the best tour
        """
        if not cities or len(cities) < 2:
            return []
        
        # Handle velocity clamping (0 means no clamping)
        v_max = velocity_clamping if velocity_clamping > 0 else None
        
        # Create PSO instance
        pso = PSO(
            cities=cities,
            swarm_size=swarm_size,
            initial_velocity=initial_velocity,
            inertia_weight=inertia_weight,
            cognitive_coef=cognitive_coef,
            social_coef=social_coef,
            velocity_clamping=v_max,
            max_iterations=max_iterations
        )
        
        # Run optimization
        best_tour = pso.optimize()
        best_distance = pso.get_best_distance()
        fitness_history = pso.get_fitness_history()
        
        # Emit signals for UI updates
        self.solutionFound.emit(best_tour, best_distance)
        self.fitnessUpdated.emit(fitness_history)
        
        return best_tour
    
    @Slot(list, str, int, float, float, float, int, result=list)
    def solve_tsp_pso_discrete(self, cities, algorithm="PSO-Discrete", swarm_size=30,
                               inertia_weight=0.7, cognitive_coef=0.8, social_coef=0.8,
                               max_swaps=10, max_iterations=100):
        """
        Solve TSP using Discrete PSO algorithm with Swap Operators
        
        Args:
            cities: List of city coordinates [{"x": x1, "y": y1}, ...]
            algorithm: Algorithm name
            swarm_size: Number of particles in swarm
            inertia_weight: Inertia weight (w)
            cognitive_coef: Cognitive coefficient (c1)
            social_coef: Social coefficient (c2)
            max_swaps: Maximum number of swaps in velocity
            max_iterations: Number of iterations
            
        Returns:
            List of city indices representing the best tour
        """
        if not cities or len(cities) < 2:
            return []
        
        # Create Discrete PSO instance
        pso = DiscretePSO(
            cities=cities,
            swarm_size=swarm_size,
            inertia_weight=inertia_weight,
            cognitive_coef=cognitive_coef,
            social_coef=social_coef,
            max_swaps=max_swaps,
            max_iterations=max_iterations
        )
        
        # Run optimization
        best_tour = pso.optimize()
        best_distance = pso.get_best_distance()
        fitness_history = pso.get_fitness_history()
        
        # Emit signals for UI updates
        self.solutionFound.emit(best_tour, best_distance)
        self.fitnessUpdated.emit(fitness_history)
        
        return best_tour
    
    @Slot(list, str, result=list)
    def solve_tsp_auto(self, cities, pso_variant="continuous"):
        """
        Automatically solve TSP with specified PSO variant
        
        Args:
            cities: List of city coordinates
            pso_variant: "continuous" (SPV) or "discrete" (Swap Operators)
            
        Returns:
            Best tour found
        """
        if pso_variant.lower() == "discrete":
            return self.solve_tsp_pso_discrete(
                cities=cities,
                algorithm="PSO-Discrete",
                swarm_size=30,
                inertia_weight=0.7,
                cognitive_coef=0.8,
                social_coef=0.8,
                max_swaps=10,
                max_iterations=100
            )
        else:  # continuous (SPV)
            return self.solve_tsp_pso(
                cities=cities,
                algorithm="PSO-Continuous",
                swarm_size=30,
                initial_velocity=0.5,
                inertia_weight=0.7,
                cognitive_coef=1.5,
                social_coef=1.5,
                velocity_clamping=1.0,
                max_iterations=100
            )
    
    @Slot(list, result=list)
    def solve_tsp(self, pts, **algo_params):
        """Legacy method - redirects to continuous PSO"""
        return self.solve_tsp_auto(pts, "continuous")