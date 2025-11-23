import numpy as np
import matplotlib.pyplot as plt


def plot_route(coords, route, title="Route"):
    route_coords = coords[route]          # lấy các điểm theo thứ tự route
    route_coords = np.vstack([route_coords, route_coords[0]])  # quay về điểm đầu

    plt.figure(figsize=(7, 7))
    plt.plot(route_coords[:, 0], route_coords[:, 1], marker='o')
    
    # đánh số điểm
    for i, (x, y) in enumerate(coords):
        plt.text(x + 0.5, y + 0.5, str(i), fontsize=9)

    plt.title(title)
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.grid(True)


def plot_convergence(list_y, labels=None, title="Convergence Curve",
                     xlabel="Iteration", ylabel="Cost"):
    """
    Vẽ biểu đồ hội tụ cho nhiều thuật toán.

    Parameters
    ----------
    list_y : list[list[float]]
        Danh sách các chuỗi giá trị hội tụ. Mỗi phần tử là 1 thuật toán.
    labels : list[str]
        Nhãn cho từng đường. Nếu None thì dùng 'Algo 1', 'Algo 2', ...
    """
    if labels is None:
        labels = [f"Algo {i+1}" for i in range(len(list_y))]

    if len(labels) != len(list_y):
        raise ValueError("Số lượng nhãn phải bằng số lượng thuật toán.")

    plt.figure(figsize=(10, 6))

    for y, lb in zip(list_y, labels):
        plt.plot(y, label=lb, linewidth=2)

    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.grid(True, linestyle="--", alpha=0.4)
    plt.legend()
    plt.tight_layout()