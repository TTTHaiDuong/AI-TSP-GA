from PySide6.QtCore import QObject, Slot
import numpy as np
import math

from core.utils import euclid


def distance_matrix_np(points):
    points = np.array(points)
    diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
    dist = np.sqrt(np.sum(diff ** 2, axis=-1))
    return dist


class CostMatrixBridge(QObject):

    @Slot(list, list, result=list)
    def buildPrototypeMatrix(self, cities, rules):
        n = len(cities)

        # rules_map[(start, end)] = rule
        rules_map = {}
        for r in rules:
            s, e = r["start"], r["end"]
            rules_map[(s, e)] = r
            rules_map[(e, s)] = r  # Cùng rule nhưng hướng khác

        # Ma trận rỗng
        matrix = [[None]*n for _ in range(n)]

        for i, ci in enumerate(cities):
            for j, cj in enumerate(cities):
                if i == j:
                    matrix[i][j] = 0.0
                    continue

                dist = euclid(ci, cj)
                oi, oj = ci["order"], cj["order"]

                rule = rules_map.get((oi, oj))

                # Ô không bị ràng buộc bởi luật, bỏ qua
                if rule is None:
                    matrix[i][j] = dist
                    continue

                direction = rule["directionType"]
                # directionType:
                # 0: chỉ cho phép từ start -> end
                # 1: chỉ cho phép từ end -> start
                # 2: cho phép cả 2 hướng
                # 3: cấm cả 2 hướng

                if direction == 3:
                    matrix[i][j] = {"dist": dist, "weight": math.inf}
                    continue

                going_start_to_end = (oi == rule["start"] and oj == rule["end"])
                going_end_to_start = not going_start_to_end

                # Chọn weight theo hướng
                if going_start_to_end:
                    weight = rule["backwardWeight"]  # start -> end
                    allowed = direction in (0, 2)
                else:
                    weight = rule["forwardWeight"]   # end -> start
                    allowed = direction in (1, 2)

                if not allowed:
                    weight = math.inf

                matrix[i][j] = {"dist": dist, "weight": weight}

        return matrix
    

    @Slot(list, result=list)
    def buildFinalMatrix(self, matrix):
        normalized = []

        for row in matrix:
            new_row = []

            for cell in row:
                if isinstance(cell, (int, float)):
                    new_row.append(cell)

                elif isinstance(cell, dict):
                    v = cell.get("dist", 0) + cell.get("weight", 0)
                    new_row.append(v)

                else:
                    raise ValueError("Kiểu dữ liệu không hợp lệ")

            normalized.append(new_row)

        return normalized