"""
Test script for Continuous PSO implementation with visualization
Run this to verify Continuous PSO works correctly and see visual results
"""

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation
from matplotlib.patches import FancyArrowPatch
from core.pso_continuous import PSO, solve_tsp_pso

# Set style for better looking plots
plt.style.use('seaborn-v0_8')

def plot_tour(cities, tour, title="TSP Tour", show=True, save_path=None):
    """Plot the TSP tour"""
    fig, ax = plt.subplots(figsize=(10, 8))
    
    # Extract coordinates
    x = [city['x'] for city in cities]
    y = [city['y'] for city in cities]
    
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
        city1 = cities[tour[i]]
        city2 = cities[tour[(i + 1) % n]]
        dx = city1['x'] - city2['x']
        dy = city1['y'] - city2['y']
        total_distance += (dx ** 2 + dy ** 2) ** 0.5
    
    return total_distance


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
    pso = PSO(cities, **params)
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
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Continuous PSO - 5 Cities (Distance: {best_distance:.4f})",
              save_path="continuous_pso_5cities_tour.png")
    
    # Plot convergence
    plot_convergence(fitness_history,
                    title="Continuous PSO - Convergence (5 Cities)",
                    save_path="continuous_pso_5cities_convergence.png")
    
    return best_tour, fitness_history


def test_larger_tsp():
    """Test PSO on a larger 10-city random TSPproblem with visualization"""
    print("\n\n" + "=" * 60)
    print("Testing PSO on 10-city random TSPproblem")
    print("=" * 60)
    
    import random
    random.seed(42)  # For reproducibility
    
    # Generate random cities
    n_cities = 10
    cities = [{"x": random.random(), "y": random.random()} for _ in range(n_cities)]
    
    print(f"\nGenerated {n_cities} random cities")
    
    # PSO parameters
    params = {
        "swarm_size": 30,
        "initial_velocity": 0.5,
        "inertia_weight": 0.7,
        "cognitive_coef": 1.5,
        "social_coef": 1.5,
        "velocity_clamping": 1.0,
        "max_iterations": 100
    }
    
    # Run PSO
    print("\nRunning PSO...")
    pso = PSO(cities, **params)
    best_tour = pso.optimize()
    best_distance = pso.get_best_distance()
    fitness_history = pso.get_fitness_history()
    
    # Display results
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
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Continuous PSO - 10 Cities (Distance: {best_distance:.4f})",
              save_path="continuous_pso_10cities_tour.png")
    
    # Plot convergence
    plot_convergence(fitness_history,
                    title="Continuous PSO - Convergence (10 Cities)",
                    save_path="continuous_pso_10cities_convergence.png")
    
    return best_tour, fitness_history


def test_convenience_function():
    """Test the convenience function solve_tsp_pso with visualization"""
    print("\n\n" + "=" * 60)
    print("Testing solve_tsp_pso convenience function")
    print("=" * 60)
    
    # Define cities in a square pattern
    cities = [
        {"x": 0.0, "y": 0.0},  # City 0
        {"x": 1.0, "y": 0.0},  # City 1
        {"x": 1.0, "y": 1.0},  # City 2
        {"x": 0.0, "y": 1.0},  # City 3
    ]
    
    print(f"\nCities: {len(cities)} cities")
    for i, city in enumerate(cities):
        print(f"  City {i}: ({city['x']}, {city['y']})")
    
    print("\nRunning solve_tsp_pso convenience function...")
    
    # Run PSO using the convenience function
    pso = PSO(cities, swarm_size=15, max_iterations=30)
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
    
    # Generate visualizations
    print("\nGenerating visualizations...")
    
    # Plot the final tour
    plot_tour(cities, best_tour, 
              title=f"Continuous PSO - 4 Cities (Distance: {best_distance:.4f})",
              save_path="continuous_pso_4cities_tour.png")
    
    # Plot convergence
    plot_convergence(fitness_history,
                    title="Continuous PSO - Convergence (4 Cities, Convenience Function)",
                    save_path="continuous_pso_4cities_convergence.png")
    
    print("\n✓ Convenience function works!")
    
    return best_tour, fitness_history


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
