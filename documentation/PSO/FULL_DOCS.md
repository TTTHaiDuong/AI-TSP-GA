# PSO (Particle Swarm Optimization) for TSP

## Overview

This implementation uses **Particle Swarm Optimization (PSO)** with the **Smallest Position Value (SPV)** approach to solve the Traveling Salesman Problem (TSP).

## How It Works

### SPV Approach
The SPV (Smallest Position Value) approach converts the continuous PSO to work with discrete permutation problems like TSP:

1. Each particle has **continuous position values** (one value per city)
2. To create a tour, we **sort the position values** 
3. The **sorted indices** become the tour order
4. Example: 
   - Position values: `[0.7, 0.2, 0.9, 0.1]`
   - Sorted indices: `[3, 1, 0, 2]` ← This is the tour

### PSO Algorithm
1. **Initialize** a swarm of particles with random positions and velocities
2. **Evaluate** each particle's fitness (tour distance)
3. **Update** velocities based on:
   - Personal best (pbest): Best position this particle has found
   - Global best (gbest): Best position any particle has found
   - Inertia: Tendency to continue in current direction
4. **Update** positions based on velocities
5. **Repeat** steps 2-4 for specified iterations

### PSO Formula
```
v = w*v + c1*r1*(pbest - x) + c2*r2*(gbest - x)
x = x + v
```

Where:
- `v`: velocity
- `x`: position
- `w`: inertia weight (exploration vs exploitation)
- `c1`: cognitive coefficient (personal best influence)
- `c2`: social coefficient (global best influence)
- `r1, r2`: random values [0, 1]

## Parameters

### Swarm Size
- **Default**: 30
- **Range**: 10-100
- **Effect**: More particles = better exploration but slower

### Initial Velocity
- **Default**: 0.5
- **Range**: 0.1-1.0
- **Effect**: Controls initial exploration speed

### Inertia Weight (w)
- **Default**: 0.7
- **Range**: 0.4-0.9
- **Effect**: 
  - High (0.9): More exploration
  - Low (0.4): More exploitation

### Cognitive Coefficient (c1)
- **Default**: 1.5
- **Range**: 0.5-2.5
- **Effect**: How much particle trusts its own experience

### Social Coefficient (c2)
- **Default**: 1.5
- **Range**: 0.5-2.5
- **Effect**: How much particle trusts swarm's experience

### Velocity Clamping
- **Default**: 1.0 (or None for no clamping)
- **Range**: 0.5-2.0
- **Effect**: Prevents velocities from becoming too large

### Number of Iterations
- **Default**: 100
- **Range**: 50-500
- **Effect**: More iterations = better solution but slower

## Usage

### Basic Usage

```python
from core.pso_continuous import solve_tsp_pso

# Define cities
cities = [
    {"x": 0.0, "y": 0.0},
    {"x": 1.0, "y": 0.0},
    {"x": 1.0, "y": 1.0},
    {"x": 0.0, "y": 1.0},
]

# Solve TSP
best_tour = solve_tsp_pso(cities)
print(f"Best tour: {best_tour}")
```

### Advanced Usage

```python
from core.pso_continuous import PSO

# Create PSO instance with custom parameters
pso = PSO(
    cities=cities,
    swarm_size=50,
    initial_velocity=0.5,
    inertia_weight=0.7,
    cognitive_coef=1.5,
    social_coef=1.5,
    velocity_clamping=1.0,
    max_iterations=200
)

# Run optimization
best_tour = pso.optimize()
best_distance = pso.get_best_distance()
fitness_history = pso.get_fitness_history()

print(f"Best tour: {best_tour}")
print(f"Best distance: {best_distance}")
print(f"Fitness history: {fitness_history}")
```

### GUI Integration

The PSO is already integrated with the GUI through `gui/controllers/route_map.py`:

```python
# In QML, call:
routeBridge.solve_tsp_pso(
    cities,           // List of cities
    "PSO",           // Algorithm name
    30,              // Swarm size
    0.5,             // Initial velocity
    0.7,             // Inertia weight
    1.5,             // Cognitive coefficient
    1.5,             // Social coefficient
    1.0,             // Velocity clamping
    100              // Max iterations
)
```

## Testing

Run the test script to verify PSO works:

```bash
python3 test_pso_continuos.py
```

## Performance Tips

1. **For small problems (< 20 cities)**:
   - Swarm size: 20-30
   - Iterations: 50-100

2. **For medium problems (20-50 cities)**:
   - Swarm size: 30-50
   - Iterations: 100-200

3. **For large problems (> 50 cities)**:
   - Swarm size: 50-100
   - Iterations: 200-500

4. **For faster convergence**:
   - Increase inertia weight (0.8-0.9)
   - Increase social coefficient (2.0-2.5)

5. **For better exploration**:
   - Increase swarm size
   - Increase initial velocity
   - Decrease inertia weight (0.4-0.6)

## Comparison with GA

| Aspect | PSO | GA |
|--------|-----|-----|
| **Approach** | Continuous optimization | Evolutionary |
| **Operators** | Velocity update | Crossover, Mutation |
| **Memory** | Remembers personal & global best | No memory |
| **Convergence** | Usually faster | Can be slower |
| **Diversity** | Can lose diversity quickly | Better diversity maintenance |
| **Parameters** | 5-6 parameters | 3-4 parameters |

## References

- Kennedy, J., & Eberhart, R. (1995). Particle swarm optimization.
- Shi, Y., & Eberhart, R. (1998). A modified particle swarm optimizer.
- Clerc, M., & Kennedy, J. (2002). The particle swarm-explosion, stability, and convergence.

## Implementation Details

- **Language**: Pure Python (no numpy dependency in core algorithm)
- **Approach**: SPV (Smallest Position Value)
- **Complexity**: O(swarm_size × iterations × n²) where n = number of cities
- **Memory**: O(swarm_size × n)
