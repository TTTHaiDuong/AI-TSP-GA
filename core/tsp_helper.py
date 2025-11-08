import math
import numpy as np


def euclide_distance(
    city1: tuple[float, float], 
    city2: tuple[float, float]
):
    x1, y1 = city1
    x2, y2 = city2
    return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)


def total_cost(
    route: list[int], 
    cost_matrix: np.ndarray
):
    route_len = len(route)
    total = 0.0

    for i in range(route_len):
        j = (i + 1) % route_len
        total += cost_matrix[route[i], route[j]]
    return total


def fitness(
    route: list[int], 
    cost_matrix: np.ndarray, 
    epsilon = 1e-9
):
    return 1 / (total_cost(route, cost_matrix) + epsilon)