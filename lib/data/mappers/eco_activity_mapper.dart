import '../dtos/eco_activity_dto.dart';
import '../../domain/entities/eco_activity.dart';

class EcoActivityMapper {
  static EcoActivity toEntity(EcoActivityDto dto) {
    return EcoActivity(
      id: dto.id,
      goalId: dto.goalId,
      description: dto.description,
      impactValue: dto.impactValue,
      type: dto.type,
      performedAt: DateTime.parse(dto.performedAt),
      evidenceImageUrl: dto.evidenceImageUrl,
      pointsEarned: dto.pointsEarned,
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
