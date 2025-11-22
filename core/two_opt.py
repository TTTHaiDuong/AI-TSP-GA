import numpy as np


def two_opt_population(population: np.ndarray, cost_matrix: np.ndarray, max_iter: int = 10):
    """
    Áp dụng 2-opt vector hóa cho tất cả tour trong quần thể.
    
    Parameters
    ----------
    population : np.ndarray
        Mảng 2D (pop_size x n_cities) chứa các tour.
    cost_matrix : np.ndarrayW
        Ma trận chi phí (n_cities x n_cities).
    max_iter : int
        Số vòng lặp tối đa để cải thiện tour.
    
    Returns
    -------
    np.ndarray
        Quần thể đã cải thiện bằng 2-opt.
    """
    pop_size, n_cities = population.shape
    
    # Tạo bản copy quần thể để sửa
    pop = population.copy()
    
    for tour_idx in range(pop_size):
        tour = pop[tour_idx]
        improved = True
        iter_count = 0
        
        while improved and iter_count < max_iter:
            improved = False
            iter_count += 1

            # Tạo tất cả cặp i,j (i < j)
            i_idx, j_idx = np.triu_indices(n_cities, k=1)
            
            # Tính chi phí 2-opt delta vectorized
            i_prev = (i_idx - 1) % n_cities
            j_next = (j_idx + 1) % n_cities
            
            delta = (
                cost_matrix[tour[i_prev], tour[j_idx]] +
                cost_matrix[tour[i_idx], tour[j_next]] -
                cost_matrix[tour[i_prev], tour[i_idx]] -
                cost_matrix[tour[j_idx], tour[j_next]]
            )
            
            # Chọn swap giảm chi phí nhất
            if np.any(delta < 0):
                best_swap = np.argmin(delta)
                i_best = i_idx[best_swap]
                j_best = j_idx[best_swap]

                # Đảo đoạn tour[i_best:j_best+1]
                tour[i_best:j_best+1] = tour[i_best:j_best+1][::-1]

                improved = True
        
        # Lưu lại tour cải thiện
        pop[tour_idx] = tour
    
    return pop