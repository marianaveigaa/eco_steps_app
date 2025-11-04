import '../dtos/sustainable_goal_dto.dart';
import '../../domain/entities/sustainable_goal.dart';

class SustainableGoalMapper {
  static SustainableGoal toEntity(SustainableGoalDto dto) {
    return SustainableGoal(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      category: dto.category,
      targetValue: dto.targetValue,
      currentValue: dto.currentValue,
      unit: dto.unit,
      deadline: DateTime.parse(dto.deadline),
      completed: dto.completed,
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
