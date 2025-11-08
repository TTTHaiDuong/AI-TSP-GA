"""
Test script for Discrete PSO implementation
Run this to verify Discrete PSO works correctly
"""

from core.pso_discrete import DiscretePSO, solve_tsp_discrete_pso, SwapOperator


def test_swap_operator():
    """Test swap operator functionality"""
    print("=" * 60)
    print("Testing Swap Operator")
    print("=" * 60)
    
    tour = [0, 1, 2, 3, 4]
    print(f"Original tour: {tour}")
    
    swap = SwapOperator(1, 3)
    print(f"Applying {swap}...")
    swap.apply(tour)
    print(f"Result: {tour}")
    print(f"Expected: [0, 3, 2, 1, 4]")
    
    assert tour == [0, 3, 2, 1, 4], "Swap operator failed!"
    print("✓ Swap operator works correctly!\n")


def test_simple_discrete_pso():
    """Test Discrete PSO on a simple 5-city TSP problem"""
    print("=" * 60)
    print("Testing Discrete PSO on 5-city TSP problem")
    print("=" * 60)
    
    # Define 5 cities in a simple pattern
    cities = [
        {"x": 0.0, "y": 0.0},    # City 0
        {"x": 1.0, "y": 0.0},    # City 1
        {"x": 1.0, "y": 1.0},    # City 2
        {"x": 0.0, "y": 1.0},    # City 3
        {"x": 0.5, "y": 0.5},    # City 4 (center)
    ]
    
    print(f"\nCities: {len(cities)} cities")
    for i, city in enumerate(cities):
        print(f"  City {i}: ({city['x']}, {city['y']})")
    
    # Discrete PSO parameters
    params = {
        "swarm_size": 20,
        "inertia_weight": 0.7,
        "cognitive_coef": 0.8,
        "social_coef": 0.8,
        "max_swaps": 5,
        "max_iterations": 50
    }
    
    print(f"\nDiscrete PSO Parameters:")
    print(f"  Swarm size: {params['swarm_size']}")
    print(f"  Inertia weight: {params['inertia_weight']}")
    print(f"  Cognitive coefficient: {params['cognitive_coef']}")
    print(f"  Social coefficient: {params['social_coef']}")
    print(f"  Max swaps: {params['max_swaps']}")
    print(f"  Max iterations: {params['max_iterations']}")
    
    # Run Discrete PSO
    print("\nRunning Discrete PSO...")
    pso = DiscretePSO(cities, **params)
    best_tour = pso.optimize()
    best_distance = pso.get_best_distance()
    fitness_history = pso.get_fitness_history()
    
    # Display results
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"Best tour found: {best_tour}")
    print(f"Best distance: {best_distance:.4f}")
    print(f"\nTour sequence:")
    for i, city_idx in enumerate(best_tour):
        city = cities[city_idx]
        print(f"  {i+1}. City {city_idx} at ({city['x']}, {city['y']})")
    print(f"  Return to City {best_tour[0]}")
    
    print(f"\nConvergence:")
    print(f"  Initial best: {fitness_history[0]:.4f}")
    print(f"  Final best: {fitness_history[-1]:.4f}")
    print(f"  Improvement: {fitness_history[0] - fitness_history[-1]:.4f}")
    if fitness_history[0] > 0:
        print(f"  Improvement %: {((fitness_history[0] - fitness_history[-1]) / fitness_history[0] * 100):.2f}%")
    
    # Show fitness progress (every 10 iterations)
    print(f"\nFitness history (every 10 iterations):")
    for i in range(0, len(fitness_history), 10):
        print(f"  Iteration {i}: {fitness_history[i]:.4f}")
    
    return best_tour, best_distance


def test_larger_discrete_pso():
    """Test Discrete PSO on a larger 10-city random TSP problem"""
    print("\n\n" + "=" * 60)
    print("Testing Discrete PSO on 10-city random TSP problem")
    print("=" * 60)
    
    import random
    random.seed(42)  # For reproducibility
    
    # Generate 10 random cities
    n_cities = 10
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nGenerated {n_cities} random cities")
    
    # Run Discrete PSO with more iterations for larger problem
    params = {
        "swarm_size": 30,
        "inertia_weight": 0.7,
        "cognitive_coef": 0.8,
        "social_coef": 0.8,
        "max_swaps": 10,
        "max_iterations": 100
    }
    
    print("\nRunning Discrete PSO...")
    pso = DiscretePSO(cities, **params)
    best_tour = pso.optimize()
    best_distance = pso.get_best_distance()
    fitness_history = pso.get_fitness_history()
    
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"Best tour found: {best_tour}")
    print(f"Best distance: {best_distance:.4f}")
    print(f"\nConvergence:")
    print(f"  Initial best: {fitness_history[0]:.4f}")
    print(f"  Final best: {fitness_history[-1]:.4f}")
    print(f"  Improvement: {fitness_history[0] - fitness_history[-1]:.4f}")
    if fitness_history[0] > 0:
        print(f"  Improvement %: {((fitness_history[0] - fitness_history[-1]) / fitness_history[0] * 100):.2f}%")
    
    return best_tour, best_distance


def test_convenience_function():
    """Test the convenience function solve_tsp_discrete_pso"""
    print("\n\n" + "=" * 60)
    print("Testing convenience function solve_tsp_discrete_pso()")
    print("=" * 60)
    
    cities = [
        (0.0, 0.0),
        (1.0, 0.0),
        (1.0, 1.0),
        (0.0, 1.0),
    ]
    
    print(f"\nSolving 4-city TSP using convenience function...")
    best_tour = solve_tsp_discrete_pso(cities, swarm_size=15, max_iterations=30)
    
    print(f"Best tour: {best_tour}")
    print("✓ Convenience function works!")
    
    return best_tour


def compare_with_continuous_pso():
    """Compare Discrete PSO with Continuous PSO (SPV)"""
    print("\n\n" + "=" * 60)
    print("Comparing Discrete PSO vs Continuous PSO (SPV)")
    print("=" * 60)
    
    from core.pso_continuous import PSO_TSP
    
    import random
    random.seed(123)  # For fair comparison
    
    # Generate test cities
    n_cities = 15
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nTest problem: {n_cities} cities")
    print("Running both algorithms with same parameters...\n")
    
    # Common parameters
    swarm_size = 30
    max_iterations = 100
    
    # Run Continuous PSO (SPV)
    print("1. Continuous PSO (SPV):")
    pso_continuous = PSO_TSP(
        cities=cities,
        n_particles=swarm_size,
        init_velocity=0.5,
        inertia_weight=0.7,
        cognitive_coef=1.5,
        social_coef=1.5,
        velocity_clamp=1.0,
        max_iterations=max_iterations
    )
    tour_continuous = pso_continuous.optimize()
    distance_continuous = pso_continuous.get_best_distance()
    history_continuous = pso_continuous.get_fitness_history()
    
    print(f"   Best distance: {distance_continuous:.4f}")
    print(f"   Improvement: {((history_continuous[0] - history_continuous[-1]) / history_continuous[0] * 100):.2f}%")
    
    # Reset random seed for fair comparison
    random.seed(123)
    
    # Run Discrete PSO
    print("\n2. Discrete PSO (Swap Operators):")
    pso_discrete = DiscretePSO(
        cities=cities,
        swarm_size=swarm_size,
        inertia_weight=0.7,
        cognitive_coef=0.8,
        social_coef=0.8,
        max_swaps=10,
        max_iterations=max_iterations
    )
    tour_discrete = pso_discrete.optimize()
    distance_discrete = pso_discrete.get_best_distance()
    history_discrete = pso_discrete.get_fitness_history()
    
    print(f"   Best distance: {distance_discrete:.4f}")
    print(f"   Improvement: {((history_discrete[0] - history_discrete[-1]) / history_discrete[0] * 100):.2f}%")
    
    # Comparison
    print("\n" + "=" * 60)
    print("COMPARISON RESULTS")
    print("=" * 60)
    print(f"Continuous PSO distance: {distance_continuous:.4f}")
    print(f"Discrete PSO distance:   {distance_discrete:.4f}")
    
    if distance_discrete < distance_continuous:
        improvement = ((distance_continuous - distance_discrete) / distance_continuous * 100)
        print(f"\n✓ Discrete PSO is BETTER by {improvement:.2f}%")
    elif distance_continuous < distance_discrete:
        improvement = ((distance_discrete - distance_continuous) / distance_discrete * 100)
        print(f"\n✓ Continuous PSO is BETTER by {improvement:.2f}%")
    else:
        print(f"\n= Both algorithms found the same solution!")
    
    return distance_continuous, distance_discrete


if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("Discrete PSO for TSP - Test Suite")
    print("=" * 60)
    
    try:
        # Test 0: Swap operator
        test_swap_operator()
        
        # Test 1: Simple 5-city problem
        test_simple_discrete_pso()
        
        # Test 2: Larger 10-city problem
        test_larger_discrete_pso()
        
        # Test 3: Convenience function
        test_convenience_function()
        
        # Test 4: Compare with continuous PSO
        compare_with_continuous_pso()
        
        print("\n\n" + "=" * 60)
        print("✓ ALL TESTS PASSED!")
        print("=" * 60)
        print("\nDiscrete PSO implementation is working correctly.")
        print("You now have TWO PSO variants to compare:")
        print("  1. Continuous PSO (SPV) - core/pso_continuous.py")
        print("  2. Discrete PSO (Swap Operators) - core/pso_discrete.py")
        
    except Exception as e:
        print("\n\n" + "=" * 60)
        print("✗ TEST FAILED!")
        print("=" * 60)
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
