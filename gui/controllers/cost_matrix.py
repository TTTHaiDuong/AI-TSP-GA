from PySide6.QtCore import QObject, Signal, Slot
import numpy as np
import math

def distance_matrix_np(points):
    points = np.array(points)
    diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
    dist = np.sqrt(np.sum(diff ** 2, axis=-1))
    return dist

def euclid(a, b):
    return math.sqrt((a["x"] - b["x"])**2 + (a["y"] - b["y"])**2)


class CostMatrixBridge(QObject):
    randomized = Signal(list)

    @Slot(list, list, result=list)
    def generate_from(self, cities, rules):
        n = len(cities)

        # Chuyển luật thành dictionary truy cập nhanh
        #   rules_map[(start, end)] = rule
        rules_map = {}
        for r in rules:
            s, e = r["start"], r["end"]
            rules_map[(s, e)] = r
            rules_map[(e, s)] = r  # cùng rule nhưng hướng khác

        # Khởi tạo ma trận rỗng
        matrix = [[None]*n for _ in range(n)]

        for i, ci in enumerate(cities):
            for j, cj in enumerate(cities):
                if i == j:
                    matrix[i][j] = 0.0
                    continue

                dist = euclid(ci, cj)
                oi, oj = ci["order"], cj["order"]

                rule = rules_map.get((oi, oj))

                # ============================
                # TRƯỜNG HỢP 1: KHÔNG CÓ LUẬT
                # ============================
                if rule is None:
                    matrix[i][j] = dist
                    continue

                print(oi, oj)

                # ============================
                # TRƯỜNG HỢP 2: CÓ LUẬT
                # ============================

                direction = rule["directionType"]
                # directionType có nghĩa:
                # 0 = CHỈ cho phép từ start → end
                # 1 = CHỈ cho phép từ end → start
                # 2 = cho phép cả 2 hướng
                # 3 = CẤM cả 2 hướng

                if direction == 3:
                    matrix[i][j] = {"dist": dist, "weight": math.inf}
                    continue

                going_start_to_end = (oi == rule["start"] and oj == rule["end"])
                going_end_to_start = not going_start_to_end

                # CHỌN weight theo hướng
                if going_start_to_end:
                    weight = rule["backwardWeight"]  # start → end
                    allowed = direction in (0, 2)
                else:
                    weight = rule["forwardWeight"]   # end → start
                    allowed = direction in (1, 2)

                if not allowed:
                    weight = math.inf

                matrix[i][j] = {"dist": dist, "weight": weight}

        return matrix