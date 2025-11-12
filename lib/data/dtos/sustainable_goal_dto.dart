class SustainableGoalDto {
  final int id;
  final String title;
  final String description;
  final String category;
  final double targetValue;
  final double currentValue;
  final String unit;
  final String deadline;
  final bool completed;
  final String updatedAt;

  SustainableGoalDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.deadline,
    required this.completed,
    required this.updatedAt,
  });

  factory SustainableGoalDto.fromMap(Map<String, dynamic> map) =>
      SustainableGoalDto(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        targetValue: (map['target_value'] as num).toDouble(),
        currentValue: (map['current_value'] as num).toDouble(),
        unit: map['unit'] as String,
        deadline: map['deadline'] as String,
        completed: map['completed'] as bool,
        updatedAt: map['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'target_value': targetValue,
        'current_value': currentValue,
        'unit': unit,
        'deadline': deadline,
        'completed': completed,
        'updated_at': updatedAt,
      };

  SustainableGoalDto copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? targetValue,
    double? currentValue,
    String? unit,
    String? deadline,
    bool? completed,
    String? updatedAt,
  }) {
    return SustainableGoalDto(
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
