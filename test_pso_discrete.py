"""
Test script for Discrete PSO implementation with visualization
Run this to verify Discrete PSO works correctly and see visual results
"""

import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import FancyArrowPatch
from core.pso_discrete import DiscretePSO, solve_tsp_discrete_pso, SwapOperator

# Set style for better looking plots
plt.style.use('seaborn-v0_8')

def plot_tour(cities, tour, title="TSP Tour", show=True, save_path=None):
    """Plot the TSP tour"""
    fig, ax = plt.subplots(figsize=(10, 8))
    
    # Extract coordinates
    if isinstance(cities[0], dict):
        x = [city['x'] for city in cities]
        y = [city['y'] for city in cities]
    else:  # Handle tuple format
        x = [city[0] for city in cities]
        y = [city[1] for city in cities]
    
    # Plot cities
    ax.scatter(x, y, c='red', s=100, zorder=5)
    
    # Add city numbers
    for i, (xi, yi) in enumerate(zip(x, y)):
        ax.annotate(str(i), (xi, yi), fontsize=12, ha='center', va='center', color='white')
    
    # Plot tour with arrows
    tour_x = [x[i] for i in tour] + [x[tour[0]]]
    tour_y = [y[i] for i in tour] + [y[tour[0]]]
    
    # Draw the path with arrows
    for i in range(len(tour)):
        start = (tour_x[i], tour_y[i])
        end = (tour_x[i+1], tour_y[i+1])
        arrow = FancyArrowPatch(start, end, 
                              arrowstyle='-|>', 
                              color='blue',
                              mutation_scale=20,
                              linewidth=2,
                              zorder=3)
        ax.add_patch(arrow)
    
    # Add start/end marker
    ax.plot(tour_x[0], tour_y[0], 'go', markersize=12, label='Start/End')
    
    # Set plot properties
    ax.set_title(f"{title}\nTour Length: {calculate_tour_distance(tour, cities):.4f}", fontsize=14)
    ax.set_xlabel('X Coordinate')
    ax.set_ylabel('Y Coordinate')
    ax.grid(True, linestyle='--', alpha=0.7)
    ax.legend()
    
    # Make sure the plot is not cut off
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
    
    if show:
        plt.show()
    
    return fig, ax

def plot_convergence(history, title="Convergence Plot", show=True, save_path=None):
    """Plot the convergence of the PSO algorithm"""
    fig, ax = plt.subplots(figsize=(10, 6))
    
    iterations = list(range(len(history)))
    ax.plot(iterations, history, 'b-', linewidth=2, label='Best Distance')
    
    # Mark the best solution
    best_iter = np.argmin(history)
    best_dist = history[best_iter]
    ax.plot(best_iter, best_dist, 'ro', markersize=8, 
            label=f'Best: {best_dist:.4f} (iter {best_iter})')
    
    ax.set_title(title, fontsize=14)
    ax.set_xlabel('Iteration')
    ax.set_ylabel('Tour Distance')
    ax.grid(True, linestyle='--', alpha=0.7)
    ax.legend()
    
    # Add some statistics
    stats = (
        f"Initial: {history[0]:.4f}\n"
        f"Final: {history[-1]:.4f}\n"
        f"Improvement: {history[0]-history[-1]:.4f} ({((history[0]-history[-1])/history[0])*100:.2f}%)"
    )
    
    ax.text(0.02, 0.02, stats, transform=ax.transAxes, 
            bbox=dict(facecolor='white', alpha=0.8, edgecolor='gray'))
    
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
    
    if show:
        plt.show()
    
    return fig, ax

def calculate_tour_distance(tour, cities):
    """Calculate the total distance of a tour"""
    total_distance = 0.0
    n = len(tour)
    
    for i in range(n):
        if isinstance(cities[0], dict):
            city1 = cities[tour[i]]
            city2 = cities[tour[(i + 1) % n]]
            dx = city1['x'] - city2['x']
            dy = city1['y'] - city2['y']
        else:  # Handle tuple format
            city1 = cities[tour[i]]
            city2 = cities[tour[(i + 1) % n]]
            dx = city1[0] - city2[0]
            dy = city1[1] - city2[1]
        total_distance += (dx ** 2 + dy ** 2) ** 0.5
    
    return total_distance


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
    """Test Discrete PSO on a simple 5-city TSP problem with visualization"""
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
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Discrete PSO - 5 Cities (Distance: {best_distance:.4f})",
              save_path="discrete_pso_5cities_tour.png")
    
    # Plot convergence
    plot_convergence(fitness_history,
                    title="Discrete PSO - Convergence (5 Cities)",
                    save_path="discrete_pso_5cities_convergence.png")
    
    return best_tour, fitness_history


def test_larger_discrete_pso():
    """Test Discrete PSO on a larger 10-city random TSP problem with visualization"""
    print("\n\n" + "=" * 60)
    print("Testing Discrete PSO on 10-city random TSP problem")
    print("=" * 60)
    
    import random
    random.seed(42)  # For reproducibility
    
    # Generate 10 random cities
    n_cities = 10
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nGenerated {n_cities} random cities")
    for i, city in enumerate(cities):
        print(f"  City {i}: ({city['x']:.4f}, {city['y']:.4f})")
    
    # Run Discrete PSO with more iterations for larger problem
    params = {
        "swarm_size": 30,
        "inertia_weight": 0.7,
        "cognitive_coef": 0.8,
        "social_coef": 0.8,
        "max_swaps": 10,
        "max_iterations": 100
    }
    
    print(f"\nDiscrete PSO Parameters:")
    print(f"  Swarm size: {params['swarm_size']}")
    print(f"  Inertia weight: {params['inertia_weight']}")
    print(f"  Cognitive coefficient: {params['cognitive_coef']}")
    print(f"  Social coefficient: {params['social_coef']}")
    print(f"  Max swaps: {params['max_swaps']}")
    print(f"  Max iterations: {params['max_iterations']}")
    
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
    
    print(f"\nTour sequence:")
    for i, city_idx in enumerate(best_tour):
        city = cities[city_idx]
        print(f"  {i+1}. City {city_idx} at ({city['x']:.4f}, {city['y']:.4f})")
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
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Discrete PSO - 10 Cities (Distance: {best_distance:.4f})",
              save_path="discrete_pso_10cities_tour.png")
    
    # Plot convergence
    plot_convergence(fitness_history,
                    title="Discrete PSO - Convergence (10 Cities)",
                    save_path="discrete_pso_10cities_convergence.png")
    
    return best_tour, fitness_history


def test_convenience_function():
    """Test the convenience function solve_tsp_discrete_pso with visualization"""
    print("\n\n" + "=" * 60)
    print("Testing convenience function solve_tsp_discrete_pso()")
    print("=" * 60)
    
    # Define cities in a square pattern
    cities = [
        (0.0, 0.0),  # City 0
        (1.0, 0.0),  # City 1
        (1.0, 1.0),  # City 2
        (0.0, 1.0),  # City 3
    ]
    
    print(f"\nCities: {len(cities)} cities")
    for i, city in enumerate(cities):
        print(f"  City {i}: {city}")
    
    print("\nSolving 4-city TSP using convenience function...")
    
    # Run the convenience function
    best_tour = solve_tsp_discrete_pso(cities, swarm_size=15, max_iterations=30)
    
    # Calculate the best distance
    best_distance = calculate_tour_distance(best_tour, cities)
    
    # Display results
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"Best tour found: {best_tour}")
    print(f"Best distance: {best_distance:.4f}")
    
    print(f"\nTour sequence:")
    for i, city_idx in enumerate(best_tour):
        city = cities[city_idx]
        print(f"  {i+1}. City {city_idx} at {city}")
    print(f"  Return to City {best_tour[0]}")
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Discrete PSO - 4 Cities (Convenience Function)\nDistance: {best_distance:.4f}",
              save_path="discrete_pso_4cities_convenience_tour.png")
    
    print("\n✓ Convenience function works!")
    
    return best_tour, best_distance


def compare_with_continuous_pso():
    """Compare Discrete PSO with Continuous PSO (SPV) with visualizations"""
    print("\n\n" + "=" * 60)
    print("Comparing Discrete PSO vs Continuous PSO (SPV)")
    print("=" * 60)
    
    from core.pso_continuous import PSO
    import random
    import numpy as np
    
    random.seed(123)  # For fair comparison
    np.random.seed(123)  # For reproducibility in numpy operations
    
    # Generate test cities
    n_cities = 15
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nTest problem: {n_cities} cities")
    print("Running both algorithms with same parameters...\n")
    
    # Common parameters
    swarm_size = 30
    max_iterations = 100
    
    results = {}
    
    # Run Continuous PSO (SPV)
    print("1. Running Continuous PSO (SPV)...")
    pso_continuous = PSO(
        cities=cities,
        swarm_size=swarm_size,
        initial_velocity=0.5,
        inertia_weight=0.7,
        cognitive_coef=1.5,
        social_coef=1.5,
        velocity_clamping=1.0,
        max_iterations=max_iterations
    )
    
    cont_best_tour = pso_continuous.optimize()
    cont_best_distance = pso_continuous.get_best_distance()
    cont_fitness_history = pso_continuous.get_fitness_history()
    
    results['continuous'] = {
        'best_tour': cont_best_tour,
        'best_distance': cont_best_distance,
        'fitness_history': cont_fitness_history,
        'cities': cities
    }
    
    print(f"   Best distance: {cont_best_distance:.4f}")
    print(f"   Final solution: {cont_best_tour}")
    
    # Run Discrete PSO
    print("\n2. Running Discrete PSO (Swap Operators)...")
    pso_discrete = DiscretePSO(
        cities=cities,
        swarm_size=swarm_size,
        inertia_weight=0.7,
        cognitive_coef=0.8,
        social_coef=0.8,
        max_swaps=10,
        max_iterations=max_iterations
    )
    
    disc_best_tour = pso_discrete.optimize()
    disc_best_distance = pso_discrete.get_best_distance()
    disc_fitness_history = pso_discrete.get_fitness_history()
    
    results['discrete'] = {
        'best_tour': disc_best_tour,
        'best_distance': disc_best_distance,
        'fitness_history': disc_fitness_history,
        'cities': cities
    }
    
    print(f"   Best distance: {disc_best_distance:.4f}")
    print(f"   Final solution: {disc_best_tour}")
    
    # Generate comparison visualizations
    print("\n" + "=" * 60)
    print("GENERATING COMPARISON VISUALIZATIONS")
    print("=" * 60)
    
    # Plot both tours side by side
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 8))
    
    # Plot Continuous PSO tour
    x = [city['x'] for city in cities]
    y = [city['y'] for city in cities]
    
    # Continuous PSO tour
    tour_x = [x[i] for i in cont_best_tour] + [x[cont_best_tour[0]]]
    tour_y = [y[i] for i in cont_best_tour] + [y[cont_best_tour[0]]]
    
    ax1.scatter(x, y, c='red', s=100, zorder=5)
    for i, (xi, yi) in enumerate(zip(x, y)):
        ax1.annotate(str(i), (xi, yi), fontsize=10, ha='center', va='center', color='white')
    
    for i in range(len(cont_best_tour)):
        start = (tour_x[i], tour_y[i])
        end = (tour_x[i+1], tour_y[i+1])
        arrow = FancyArrowPatch(start, end, 
                              arrowstyle='-|>', 
                              color='blue',
                              mutation_scale=15,
                              linewidth=1.5,
                              zorder=3)
        ax1.add_patch(arrow)
    
    ax1.plot(tour_x[0], tour_y[0], 'go', markersize=10, label='Start/End')
    ax1.set_title(f"Continuous PSO (SPV)\nDistance: {cont_best_distance:.4f}")
    ax1.grid(True, linestyle='--', alpha=0.7)
    
    # Discrete PSO tour
    tour_x = [x[i] for i in disc_best_tour] + [x[disc_best_tour[0]]]
    tour_y = [y[i] for i in disc_best_tour] + [y[disc_best_tour[0]]]
    
    ax2.scatter(x, y, c='red', s=100, zorder=5)
    for i, (xi, yi) in enumerate(zip(x, y)):
        ax2.annotate(str(i), (xi, yi), fontsize=10, ha='center', va='center', color='white')
    
    for i in range(len(disc_best_tour)):
        start = (tour_x[i], tour_y[i])
        end = (tour_x[i+1], tour_y[i+1])
        arrow = FancyArrowPatch(start, end, 
                              arrowstyle='-|>', 
                              color='green',
                              mutation_scale=15,
                              linewidth=1.5,
                              zorder=3)
        ax2.add_patch(arrow)
    
    ax2.plot(tour_x[0], tour_y[0], 'go', markersize=10, label='Start/End')
    ax2.set_title(f"Discrete PSO (Swaps)\nDistance: {disc_best_distance:.4f}")
    ax2.grid(True, linestyle='--', alpha=0.7)
    
    plt.tight_layout()
    plt.savefig("pso_comparison_tours.png", dpi=300, bbox_inches='tight')
    
    # Plot convergence comparison
    plt.figure(figsize=(12, 6))
    
    # Ensure both histories have the same length for fair comparison
    min_len = min(len(cont_fitness_history), len(disc_fitness_history))
    iterations = list(range(min_len))
    
    plt.plot(iterations, cont_fitness_history[:min_len], 'b-', linewidth=2, label='Continuous PSO (SPV)')
    plt.plot(iterations, disc_fitness_history[:min_len], 'g-', linewidth=2, label='Discrete PSO (Swaps)')
    
    plt.title('Convergence Comparison: Continuous vs Discrete PSO')
    plt.xlabel('Iteration')
    plt.ylabel('Tour Distance')
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.legend()
    
    # Add some statistics
    stats = (
        f"Continuous PSO: {cont_best_distance:.4f} (Improvement: {cont_fitness_history[0]-cont_fitness_history[-1]:.4f})\n"
        f"Discrete PSO: {disc_best_distance:.4f} (Improvement: {disc_fitness_history[0]-disc_fitness_history[-1]:.4f})"
    )
    
    plt.text(0.02, 0.02, stats, transform=plt.gca().transAxes, 
            bbox=dict(facecolor='white', alpha=0.8, edgecolor='gray'))
    
    plt.tight_layout()
    plt.savefig("pso_convergence_comparison.png", dpi=300, bbox_inches='tight')
    
    print("\nComparison visualizations saved as:")
    print("  - pso_comparison_tours.png")
    print("  - pso_convergence_comparison.png")
    
    return results
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
        # Run all tests with timing
        start_time = time.time()
        
        try:
            print("\n" + "#" * 60)
            print("TEST 1: Simple 5-city TSP Problem")
            print("#" * 60)
            test_simple_discrete_pso()
            
            print("\n" + "#" * 60)
            print("TEST 2: Larger 10-city Random TSP Problem")
            print("#" * 60)
            test_larger_discrete_pso()
            
            print("\n" + "#" * 60)
            print("TEST 3: Convenience Function Test")
            print("#" * 60)
            test_convenience_function()
            
            print("\n" + "#" * 60)
            print("TEST 4: Comparison with Continuous PSO (SPV)")
            print("#" * 60)
            compare_with_continuous_pso()
            
            # Calculate total execution time
            total_time = time.time() - start_time
            
            print("\n" + "=" * 60)
            print("TEST SUITE COMPLETED SUCCESSFULLY!")
            print("=" * 60)
            print(f"Total execution time: {total_time:.2f} seconds")
            print("\nGenerated visualizations:")
            print("- discrete_pso_5cities_tour.png")
            print("- discrete_pso_5cities_convergence.png")
            print("- discrete_pso_10cities_tour.png")
            print("- discrete_pso_10cities_convergence.png")
            print("- discrete_pso_4cities_convenience_tour.png")
            print("- pso_comparison_tours.png")
            print("- pso_convergence_comparison.png")
            
            # Show all plots at the end
            plt.show()
            
        except Exception as e:
            print(f"\nERROR: Test failed with exception: {str(e)}")
            import traceback
            traceback.print_exc()
            print("\n" + "!" * 60)
            print("TEST SUITE FAILED!")
            print("!" * 60)
            print(f"Execution time before failure: {time.time() - start_time:.2f} seconds")
        
    except Exception as e:
        print("\n\n" + "=" * 60)
        print("✗ TEST FAILED!")
        print("=" * 60)
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
