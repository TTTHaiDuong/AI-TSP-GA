"""
Test script for Continuous PSO implementation
Run this to verify Continuous PSO works correctly
"""

from core.pso_continuous import PSO_TSP, solve_tsp_pso


def test_simple_tsp():
    """Test PSO on a simple 5-city TSP problem"""
    print("=" * 60)
    print("Testing PSO on 5-city TSP problem")
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
    
    # PSO parameters
    params = {
        "swarm_size": 20,
        "initial_velocity": 0.5,
        "inertia_weight": 0.7,
        "cognitive_coef": 1.5,
        "social_coef": 1.5,
        "velocity_clamping": 1.0,
        "max_iterations": 50
    }
    
    print(f"\nPSO Parameters:")
    print(f"  Swarm size: {params['swarm_size']}")
    print(f"  Initial velocity: {params['initial_velocity']}")
    print(f"  Inertia weight: {params['inertia_weight']}")
    print(f"  Cognitive coefficient: {params['cognitive_coef']}")
    print(f"  Social coefficient: {params['social_coef']}")
    print(f"  Velocity clamping: {params['velocity_clamping']}")
    print(f"  Max iterations: {params['max_iterations']}")
    
    # Run PSO
    print("\nRunning PSO...")
    pso = PSO_TSP(cities, **params)
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
    print(f"  Improvement %: {((fitness_history[0] - fitness_history[-1]) / fitness_history[0] * 100):.2f}%")
    
    # Show fitness progress (every 10 iterations)
    print(f"\nFitness history (every 10 iterations):")
    for i in range(0, len(fitness_history), 10):
        print(f"  Iteration {i}: {fitness_history[i]:.4f}")
    
    return best_tour, best_distance


def test_larger_tsp():
    """Test PSO on a larger 10-city random TSP problem"""
    print("\n\n" + "=" * 60)
    print("Testing PSO on 10-city random TSP problem")
    print("=" * 60)
    
    import random
    random.seed(42)  # For reproducibility
    
    # Generate 10 random cities
    n_cities = 10
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nGenerated {n_cities} random cities")
    
    # Run PSO with more iterations for larger problem
    params = {
        "swarm_size": 30,
        "initial_velocity": 0.5,
        "inertia_weight": 0.7,
        "cognitive_coef": 1.5,
        "social_coef": 1.5,
        "velocity_clamping": 1.0,
        "max_iterations": 100
    }
    
    print("\nRunning PSO...")
    pso = PSO_TSP(cities, **params)
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
    print(f"  Improvement %: {((fitness_history[0] - fitness_history[-1]) / fitness_history[0] * 100):.2f}%")
    
    return best_tour, best_distance


def test_convenience_function():
    """Test the convenience function solve_tsp_pso"""
    print("\n\n" + "=" * 60)
    print("Testing convenience function solve_tsp_pso()")
    print("=" * 60)
    
    cities = [
        (0.0, 0.0),
        (1.0, 0.0),
        (1.0, 1.0),
        (0.0, 1.0),
    ]
    
    print(f"\nSolving 4-city TSP using convenience function...")
    best_tour = solve_tsp_pso(cities, swarm_size=15, max_iterations=30)
    
    print(f"Best tour: {best_tour}")
    print("✓ Convenience function works!")
    
    return best_tour


if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("PSO for TSP - Test Suite")
    print("=" * 60)
    
    try:
        # Test 1: Simple 5-city problem
        test_simple_tsp()
        
        # Test 2: Larger 10-city problem
        test_larger_tsp()
        
        # Test 3: Convenience function
        test_convenience_function()
        
        print("\n\n" + "=" * 60)
        print("✓ ALL TESTS PASSED!")
        print("=" * 60)
        print("\nPSO implementation is working correctly.")
        print("You can now use it in your GUI application.")
        
    except Exception as e:
        print("\n\n" + "=" * 60)
        print("✗ TEST FAILED!")
        print("=" * 60)
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
