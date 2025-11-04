class SustainableGoal {
  final int id;
  final String title;
  final String description;
  final String category;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime deadline;
  final bool completed;
  final DateTime updatedAt;

  SustainableGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.deadline,
    this.completed = false,
    required this.updatedAt,
  });

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
  String get progressText => '${(progress * 100).toStringAsFixed(0)}%';
}
