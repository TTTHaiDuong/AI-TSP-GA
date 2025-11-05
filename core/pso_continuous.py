"""
Particle Swarm Optimization (PSO) for Traveling Salesman Problem (TSP)
Using Smallest Position Value (SPV) approach for continuous PSO on discrete problem

The SPV approach works by:
1. Each particle has continuous position values (one per city)
2. To get a tour, we sort the position values and use the sorted indices as the tour
3. Smaller position values come first in the tour
"""

import random
import math


class Particle:
    """Represents a single particle in the swarm"""
    
    def __init__(self, n_cities, initial_velocity=0.5):
        """
        Initialize a particle with random position and velocity
        
        Args:
            n_cities: Number of cities in TSP
            initial_velocity: Initial velocity magnitude
        """
        self.n_cities = n_cities
        # Position: continuous values that will be sorted to create tour
        self.position = [random.random() for _ in range(n_cities)]
        # Velocity: rate of change of position
        self.velocity = [random.uniform(-initial_velocity, initial_velocity) 
                        for _ in range(n_cities)]
        
        # Personal best
        self.pbest_position = self.position[:]
        self.pbest_fitness = float('inf')
        
        # Current fitness
        self.fitness = float('inf')
    
    def get_tour(self):
        """
        Convert continuous position to discrete tour using SPV
        Returns tour as list of city indices
        """
        # Create pairs of (position_value, city_index)
        indexed_positions = [(self.position[i], i) for i in range(self.n_cities)]
        # Sort by position value (smallest position value)
        indexed_positions.sort()
        # Extract city indices to form tour
        tour = [city_idx for _, city_idx in indexed_positions]
        return tour
    
    def update_velocity(self, gbest_position, w, c1, c2, v_max=None):
        """
        Update particle velocity using PSO formula
        
        Args:
            gbest_position: Global best position
            w: Inertia weight
            c1: Cognitive coefficient (personal best influence)
            c2: Social coefficient (global best influence)
            v_max: Maximum velocity (velocity clamping)
        """
        for i in range(self.n_cities):
            r1 = random.random()
            r2 = random.random()
            
            # PSO velocity update formula
            # v = w*v + c1*r1*(pbest - x) + c2*r2*(gbest - x)
            cognitive = c1 * r1 * (self.pbest_position[i] - self.position[i])
            social = c2 * r2 * (gbest_position[i] - self.position[i])
            
            self.velocity[i] = w * self.velocity[i] + cognitive + social
            
            # Apply velocity clamping if specified
            if v_max is not None:
                if self.velocity[i] > v_max:
                    self.velocity[i] = v_max
                elif self.velocity[i] < -v_max:
                    self.velocity[i] = -v_max
    
    def update_position(self):
        """Update particle position based on velocity"""
        for i in range(self.n_cities):
            self.position[i] += self.velocity[i]


class PSO:
    """Particle Swarm Optimization for TSP"""
    
    def __init__(self, cities, swarm_size=30, initial_velocity=0.5, 
                 inertia_weight=0.7, cognitive_coef=1.5, social_coef=1.5,
                 velocity_clamping=None, max_iterations=100):
        """
        Initialize PSO algorithm
        
        Args:
            cities: List of city coordinates [(x1, y1), (x2, y2), ...] or [{"x": x1, "y": y1}, ...]
            swarm_size: Number of particles in swarm
            initial_velocity: Initial velocity magnitude
            inertia_weight: Inertia weight (w) - controls exploration vs exploitation
            cognitive_coef: Cognitive coefficient (c1) - personal best influence
            social_coef: Social coefficient (c2) - global best influence
            velocity_clamping: Maximum velocity (None for no clamping)
            max_iterations: Maximum number of iterations
        """
        # Convert cities to tuple format if dict format
        if cities and isinstance(cities[0], dict):
            self.cities = [(city["x"], city["y"]) for city in cities]
        else:
            self.cities = cities
            
        self.n_cities = len(self.cities)
        self.swarm_size = swarm_size
        self.initial_velocity = initial_velocity
        self.w = inertia_weight
        self.c1 = cognitive_coef
        self.c2 = social_coef
        self.v_max = velocity_clamping
        self.max_iterations = max_iterations
        
        # Initialize swarm
        self.swarm = [Particle(self.n_cities, self.initial_velocity) 
                     for _ in range(self.swarm_size)]
        
        # Global best
        self.gbest_position = None
        self.gbest_fitness = float('inf')
        self.gbest_tour = None
        
        # History for tracking convergence
        self.fitness_history = []
    
    def calculate_distance(self, city1_idx, city2_idx):
        """Calculate Euclidean distance between two cities"""
        x1, y1 = self.cities[city1_idx]
        x2, y2 = self.cities[city2_idx]
        return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    
    def calculate_tour_distance(self, tour):
        """Calculate total distance of a tour"""
        total_distance = 0.0
        for i in range(len(tour)):
            city1 = tour[i]
            city2 = tour[(i + 1) % len(tour)]  # Wrap around to first city
            total_distance += self.calculate_distance(city1, city2)
        return total_distance
    
    def evaluate_particle(self, particle):
        """Evaluate fitness of a particle"""
        tour = particle.get_tour()
        fitness = self.calculate_tour_distance(tour)
        return fitness, tour
    
    def optimize(self):
        """
        Run PSO optimization
        
        Returns:
            best_tour: List of city indices representing best tour found
        """
        # Initial evaluation
        for particle in self.swarm:
            fitness, tour = self.evaluate_particle(particle)
            particle.fitness = fitness
            
            # Update personal best
            if fitness < particle.pbest_fitness:
                particle.pbest_fitness = fitness
                particle.pbest_position = particle.position[:]
            
            # Update global best
            if fitness < self.gbest_fitness:
                self.gbest_fitness = fitness
                self.gbest_position = particle.position[:]
                self.gbest_tour = tour
        
        self.fitness_history.append(self.gbest_fitness)
        
        # Main PSO loop
        for iteration in range(self.max_iterations):
            for particle in self.swarm:
                # Update velocity and position
                particle.update_velocity(self.gbest_position, self.w, 
                                       self.c1, self.c2, self.v_max)
                particle.update_position()
                
                # Evaluate new position
                fitness, tour = self.evaluate_particle(particle)
                particle.fitness = fitness
                
                # Update personal best
                if fitness < particle.pbest_fitness:
                    particle.pbest_fitness = fitness
                    particle.pbest_position = particle.position[:]
                
                # Update global best
                if fitness < self.gbest_fitness:
                    self.gbest_fitness = fitness
                    self.gbest_position = particle.position[:]
                    self.gbest_tour = tour
            
            # Record fitness history
            self.fitness_history.append(self.gbest_fitness)
        
        return self.gbest_tour
    
    def get_best_distance(self):
        """Get the distance of the best tour found"""
        return self.gbest_fitness
    
    def get_fitness_history(self):
        """Get fitness history for plotting convergence"""
        return self.fitness_history


def solve_tsp_pso(cities, swarm_size=30, initial_velocity=0.5,
                  inertia_weight=0.7, cognitive_coef=1.5, social_coef=1.5,
                  velocity_clamping=None, max_iterations=100):
    """
    Convenience function to solve TSP using PSO
    
    Args:
        cities: List of city coordinates [(x1, y1), (x2, y2), ...] or [{"x": x1, "y": y1}, ...]
        swarm_size: Number of particles
        initial_velocity: Initial velocity magnitude
        inertia_weight: Inertia weight (w)
        cognitive_coef: Cognitive coefficient (c1)
        social_coef: Social coefficient (c2)
        velocity_clamping: Maximum velocity
        max_iterations: Number of iterations
    
    Returns:
        best_tour: List of city indices representing best tour
    """
    pso = PSO(cities, swarm_size, initial_velocity, inertia_weight,
              cognitive_coef, social_coef, velocity_clamping, max_iterations)
    best_tour = pso.optimize()
    return best_tour
