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

  SustainableGoal copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? targetValue,
    double? currentValue,
    String? unit,
    DateTime? deadline,
    bool? completed,
    DateTime? updatedAt,
  }) {
    return SustainableGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      deadline: deadline ?? this.deadline,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
