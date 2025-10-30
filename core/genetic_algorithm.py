import random

class GeneticAlgorithm:
    def __init__(self, cities, population_size, mutation_rate, crossover_rate, elitism_count):
        """
        Khởi tạo thuật toán di truyền.
        :param cities: List các tuple tọa độ (x, y) của các thành phố.
        :param population_size: Kích thước quần thể.
        :param mutation_rate: Tỷ lệ đột biến.
        :param crossover_rate: Tỷ lệ lai ghép.
        :param elitism_count: Số lượng cá thể tốt nhất được giữ lại cho thế hệ sau.
        """
        self.cities = cities
        self.population_size = population_size
        self.mutation_rate = mutation_rate
        self.crossover_rate = crossover_rate
        self.elitism_count = elitism_count

        self.population = self._initialize_population()

    def _calculate_distance(self, city1, city2):
        """Tính khoảng cách Euclide giữa 2 thành phố."""
        return ((city1[0] - city2[0]) ** 2 + (city1[1] - city2[1]) ** 2) ** 0.5

    def _calculate_fitness(self, chromosome):
        """
        Hàm Fitness: Tính tổng quãng đường của một lộ trình (chromosome).
        Giá trị trả về càng nhỏ, cá thể càng tốt.
        """
        total_distance = 0
        num_cities = len(chromosome)
        for i in range(num_cities):
            start_city_index = chromosome[i]
            # Nếu là thành phố cuối cùng, đích đến là thành phố đầu tiên
            end_city_index = chromosome[(i + 1) % num_cities]

            start_city = self.cities[start_city_index]
            end_city = self.cities[end_city_index]

            total_distance += self._calculate_distance(start_city, end_city)
        return total_distance

    def _initialize_population(self):
        """Tạo quần thể ban đầu với các lộ trình ngẫu nhiên."""
        population = []
        city_indices = list(range(len(self.cities)))
        for _ in range(self.population_size):
            chromosome = city_indices[:]
            random.shuffle(chromosome)
            population.append(chromosome)
        return population

    def _selection(self, sorted_population_with_fitness):
        """
        Chọn lọc cha mẹ bằng phương pháp Tournament Selection.
        """
        tournament_size = 5  # Có thể điều chỉnh kích thước này

        # Lấy ngẫu nhiên các cá thể tham gia "giải đấu"
        # Đảm bảo population_size lớn hơn tournament_size
        if len(sorted_population_with_fitness) < tournament_size:
            tournament_contenders = sorted_population_with_fitness
        else:
            tournament_contenders = random.sample(sorted_population_with_fitness, tournament_size)

        # Tìm cá thể tốt nhất (có fitness nhỏ nhất) trong nhóm đấu
        # x[0] là chromosome, x[1] là fitness
        best_contender = min(tournament_contenders, key=lambda x: x[1])

        return best_contender[0]  # Trả về chromosome của cá thể thắng cuộc

    def _crossover(self, parent1, parent2):
        """
        Lai ghép hai cha mẹ bằng phương pháp Ordered Crossover (OX1).
        """
        size = len(parent1)
        child = [None] * size

        # 1. Chọn ngẫu nhiên một đoạn gen từ cha mẹ 1
        start, end = sorted(random.sample(range(size), 2))

        # 2. Sao chép đoạn gen này vào con
        child[start:end] = parent1[start:end]

        # 3. Lấy các gen từ cha mẹ 2 mà chưa có trong con
        parent2_genes = [item for item in parent2 if item not in child]

        # 4. Điền các gen còn lại vào con
        pointer = 0
        for i in range(size):
            if child[i] is None:
                child[i] = parent2_genes[pointer]
                pointer += 1

        return child

    def _mutation(self, chromosome):
        """
        Đột biến một cá thể bằng cách hoán đổi vị trí 2 gen (Swap Mutation).
        """
        if random.random() < self.mutation_rate:
            # Chọn 2 chỉ số ngẫu nhiên và khác nhau để hoán đổi
            idx1, idx2 = random.sample(range(len(chromosome)), 2)

            # Hoán đổi giá trị
            chromosome[idx1], chromosome[idx2] = chromosome[idx2], chromosome[idx1]

    def evolve(self):
        """
        Thực hiện một vòng đời (thế hệ) của thuật toán.
        """
        # 1. Đánh giá fitness cho toàn bộ quần thể
        # Tạo một list các tuple (chromosome, fitness) và sắp xếp
        sorted_population_with_fitness = sorted(
            [(chromo, self._calculate_fitness(chromo)) for chromo in self.population],
            key=lambda x: x[1]  # Sắp xếp theo fitness (quãng đường) tăng dần
        )

        next_generation = []

        # 2. Elitism: Giữ lại những cá thể tốt nhất
        for i in range(self.elitism_count):
            next_generation.append(sorted_population_with_fitness[i][0])

        # 3. Tạo ra các cá thể mới bằng lai ghép và đột biến
        while len(next_generation) < self.population_size:
            # Chọn lọc cha mẹ
            parent1 = self._selection(sorted_population_with_fitness)
            parent2 = self._selection(sorted_population_with_fitness)

            # Lai ghép
            if random.random() < self.crossover_rate:
                child = self._crossover(parent1, parent2)
            else:
                child = parent1[:]  # Nếu không lai ghép thì giữ lại cha mẹ

            # Đột biến
            self._mutation(child)

            next_generation.append(child)

        self.population = next_generation

        # Trả về lộ trình tốt nhất và fitness của thế hệ hiện tại
        best_chromosome = sorted_population_with_fitness[0][0]
        best_fitness = sorted_population_with_fitness[0][1]
        return best_chromosome, best_fitness