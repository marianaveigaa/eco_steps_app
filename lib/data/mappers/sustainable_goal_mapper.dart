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

  // --- ADICIONAR ESTE MÉTODO ---
  /// Converte a Entidade (do app) para um DTO (para o Supabase/cache)
  static SustainableGoalDto toDto(SustainableGoal entity) {
    return SustainableGoalDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      targetValue: entity.targetValue,
      currentValue: entity.currentValue,
      unit: entity.unit,
      deadline: entity.deadline.toIso8601String(),
      completed: entity.completed,
      // O updatedAt deve ser atualizado no momento de salvar
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}
