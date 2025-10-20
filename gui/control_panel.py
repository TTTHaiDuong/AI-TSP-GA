from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QFormLayout,
    QLabel,
    QSlider,
    QSpinBox,
    QComboBox,
    QPushButton,
    QDoubleSpinBox,
    QFormLayout
)
from PySide6.QtCore import Qt


class ControlPanel(QWidget):
    """Thanh điều khiển bên trái chứa các tham số và nút bấm."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.main_layout = QVBoxLayout(self)
        self.main_layout.setAlignment(Qt.AlignmentFlag.AlignTop)

        # -- Topology Section --
        self.main_layout.addWidget(QLabel("<b>Topology</b>"))
        form_layout_1 = QFormLayout()
        self.nodes_slider = QSlider(Qt.Orientation.Horizontal)
        self.nodes_slider.setRange(5, 100)
        self.nodes_slider.setValue(20)
        form_layout_1.addRow("Nodes:", self.nodes_slider)
        self.seed_input = QSpinBox()
        self.seed_input.setRange(0, 9999)
        self.seed_input.setValue(42)
        form_layout_1.addRow("Seed:", self.seed_input)
        self.main_layout.addLayout(form_layout_1)

        # -- Algorithm Section --
        self.main_layout.addWidget(QLabel("<b>Algorithm Parameters</b>"))
        form_layout_2 = QFormLayout()
        self.algorithm_combo = QComboBox()
        self.algorithm_combo.addItems(["Genetic Algorithm", "Local Search (2-opt)"])
        form_layout_2.addRow("Method:", self.algorithm_combo)

        # --- GA Parameters ---
        self.population_input = QSpinBox()
        self.population_input.setRange(10, 1000)
        self.population_input.setValue(200)
        form_layout_2.addRow("Population Size:", self.population_input)
        self.ga_pop_row = ("Population Size:", self.population_input)

        self.generations_input = QSpinBox()
        self.generations_input.setRange(10, 5000)
        self.generations_input.setValue(100)
        form_layout_2.addRow("Generations:", self.generations_input)
        self.ga_gen_row = ("Generations:", self.generations_input)

        self.mutation_rate_input = QDoubleSpinBox()
        self.mutation_rate_input.setRange(0.0, 1.0)
        self.mutation_rate_input.setSingleStep(0.01)
        self.mutation_rate_input.setValue(0.05)
        form_layout_2.addRow("Mutation Rate:", self.mutation_rate_input)
        self.ga_mut_row = ("Mutation Rate:", self.mutation_rate_input)

        self.main_layout.addLayout(form_layout_2)
        self.form_layout_2 = form_layout_2  # Store reference to form layout for later use

        # -- Solve Button --
        self.solve_button = QPushButton("Solve TSP")
        self.main_layout.addWidget(self.solve_button)

        # Connect signals to hide/show parameters
        self.algorithm_combo.currentTextChanged.connect(self.update_parameters_visibility)
        self.update_parameters_visibility("Genetic Algorithm")  # Initial call

    def update_parameters_visibility(self, algorithm_name):
        """Show/hide parameters based on the selected algorithm."""
        is_ga = (algorithm_name == "Genetic Algorithm")
        
        # Show/hide GA parameters
        for label, widget in [self.ga_pop_row, self.ga_gen_row, self.ga_mut_row]:
            row = self.form_layout_2.rowCount() - 1
            for i in range(self.form_layout_2.rowCount()):
                item = self.form_layout_2.itemAt(i, QFormLayout.ItemRole.LabelRole)
                if item and item.widget() and item.widget().text().startswith(label[0]):
                    row = i
                    break
            
            label_item = self.form_layout_2.itemAt(row, QFormLayout.ItemRole.LabelRole)
            field_item = self.form_layout_2.itemAt(row, QFormLayout.ItemRole.FieldRole)
            
            if label_item and label_item.widget():
                label_item.widget().setVisible(is_ga)
            if field_item and field_item.widget():
                field_item.widget().setVisible(is_ga)