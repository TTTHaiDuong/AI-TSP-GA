import random
import time
import math
import matplotlib.pyplot as plt
import tracemalloc

# ============================================================
#   HELPER: Random TSP instance (10–20 cities)
# ============================================================
def generate_random_cities():
    n = random.randint(10, 20)
    cities = [(random.randint(0, 100), random.randint(0, 100)) for _ in range(n)]
    return cities

def build_distance_matrix(cities):
    n = len(cities)
    dist = [[0]*n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if i != j:
                (x1, y1) = cities[i]
                (x2, y2) = cities[j]
                dist[i][j] = math.dist((x1, y1), (x2, y2))
    return dist


# ============================================================
#   DUMMY ALGO RESULTS (mock)
#   -> sẽ thay bằng import từ SA/ACO/HK thật sau
# ============================================================
def run_SA(dist_matrix):
    time.sleep(0.1)  # giả lập chạy

    return {
        "name": "SA",
        "best_cost": random.uniform(200, 400),
        "best_tour": [0, 2, 4, 1, 5, 3],
        "time_us": random.randint(300_000, 500_000),
        "fitness_calls": random.randint(500, 1000),
        "memory_kb": random.uniform(400, 800),
        "history": [900, 700, 620, 580, 530, 500, 470, 450, 430],
    }

def run_ACO(dist_matrix):
    time.sleep(0.15)

    return {
        "name": "ACO",
        "best_cost": random.uniform(180, 420),
        "best_tour": [0, 2, 4, 1, 5, 3],
        "time_us": random.randint(500_000, 800_000),
        "fitness_calls": random.randint(700, 1500),
        "memory_kb": random.uniform(500, 1000),
        "history": [1000, 850, 760, 700, 650, 600, 580, 560, 540, 520, 510],
    }

def run_HeldKarp(dist_matrix):
    time.sleep(0.05)

    return {
        "name": "Held-Karp",
        "best_cost": random.uniform(150, 350),
        "best_tour": [0, 2, 4, 1, 5, 3],
        "time_us": random.randint(200_000, 300_000),
        "fitness_calls": random.randint(300, 600),
        "memory_kb": random.uniform(300, 500),
        "history": [2000, 1500, 1100, 900, 650, 500, 450, 420, 410],
    }


# ============================================================
#   HELPER: Add values on top of bars
# ============================================================
def add_value_labels(ax, unit=""):
    """Add text labels above bars"""
    for rect in ax.patches:
        height = rect.get_height()
        ax.annotate(
            f"{height:.1f}{unit}",
            xy=(rect.get_x() + rect.get_width() / 2, height),
            xytext=(0, 5),
            textcoords="offset points",
            ha='center',
            va='bottom',
            fontsize=9
        )


# ============================================================
#   PLOT 1: TIME + MEMORY
# ============================================================
def plot_time_memory(results):
    names = [r["name"] for r in results]
    times = [r["time_us"] / 1000 for r in results]  # chuyển sang ms
    mems = [r["memory_kb"] for r in results]

    x = range(len(names))
    width = 0.35

    plt.figure(figsize=(10, 5))
    ax = plt.gca()

    ax.bar([i - width/2 for i in x], times, width, label="Time (ms)")
    ax.bar([i + width/2 for i in x], mems, width, label="Memory (KB)")

    plt.xticks(x, names)
    plt.title("Comparison: Time (ms) & Memory (KB)")
    plt.legend()

    add_value_labels(ax, "")  # đơn vị đã ghi trong label

    plt.tight_layout()
    plt.show()


# ============================================================
#   PLOT 2: FITNESS CALLS + BEST COST
# ============================================================
def plot_fitness_cost(results):
    names = [r["name"] for r in results]
    fitness_calls = [r["fitness_calls"] for r in results]
    best_costs = [r["best_cost"] for r in results]

    x = range(len(names))
    width = 0.35

    plt.figure(figsize=(10, 5))
    ax = plt.gca()

    ax.bar([i - width/2 for i in x], fitness_calls, width, label="Fitness Calls")
    ax.bar([i + width/2 for i in x], best_costs, width, label="Best Cost")

    plt.xticks(x, names)
    plt.title("Comparison: Fitness Calls & Best Cost")
    plt.legend()

    add_value_labels(ax, "")  # đơn vị tùy theo label

    plt.tight_layout()
    plt.show()


# ============================================================
#   PLOT 3: HISTORY (LINE PLOT)
# ============================================================
def plot_history(results):
    plt.figure(figsize=(10, 5))

    for r in results:
        plt.plot(r["history"], label=r["name"])

    plt.xlabel("Iteration")
    plt.ylabel("Cost")
    plt.title("Convergence History")
    plt.legend()
    plt.tight_layout()
    plt.show()


# ============================================================
#   MAIN
# ============================================================
def main():
    # Create TSP dataset
    cities = generate_random_cities()
    dist = build_distance_matrix(cities)

    print("\n===== Running Algorithms on TSP Instance =====")

    # Running
    results = []
    results.append(run_SA(dist))
    results.append(run_ACO(dist))
    results.append(run_HeldKarp(dist))

    # Print results
    print("\n===== RESULTS =====")
    for r in results:
        print(f"\n--- {r['name']} ---")
        print(f"Best cost      : {r['best_cost']:.2f}")
        print(f"Time (ms)      : {r['time_us']/1000:.2f}")
        print(f"Memory (KB)    : {r['memory_kb']:.2f}")
        print(f"Fitness calls  : {r['fitness_calls']}")
        print(f"Best tour    : {r['best_tour']}")
        print("---------------------------")

    # Plots
    plot_time_memory(results)
    plot_fitness_cost(results)
    plot_history(results)


if __name__ == "__main__":
    main()
