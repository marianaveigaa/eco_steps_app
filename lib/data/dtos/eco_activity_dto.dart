class EcoActivityDto {
  final int id;
  final int goalId;
  final String description;
  final double impactValue;
  final String type;
  final String performedAt;
  final String? evidenceImageUrl;
  final int pointsEarned;
  final String updatedAt;

  EcoActivityDto({
    required this.id,
    required this.goalId,
    required this.description,
    required this.impactValue,
    required this.type,
    required this.performedAt,
    this.evidenceImageUrl,
    required this.pointsEarned,
    required this.updatedAt,
  });

  factory EcoActivityDto.fromMap(Map<String, dynamic> map) => EcoActivityDto(
        id: map['id'] as int,
        goalId: map['goal_id'] as int,
        description: map['description'] as String,
        impactValue: (map['impact_value'] as num).toDouble(),
        type: map['type'] as String,
        performedAt: map['performed_at'] as String,
        evidenceImageUrl: map['evidence_image_url'] as String?,
        pointsEarned: map['points_earned'] as int,
        updatedAt: map['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'goal_id': goalId,
        'description': description,
        'impact_value': impactValue,
        'type': type,
        'performed_at': performedAt,
        'evidence_image_url': evidenceImageUrl,
        'points_earned': pointsEarned,
        'updated_at': updatedAt,
      };
}
