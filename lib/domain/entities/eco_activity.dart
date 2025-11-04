class EcoActivity {
  final int id;
  final int goalId;
  final String description;
  final double impactValue;
  final String type;
  final DateTime performedAt;
  final String? evidenceImageUrl;
  final int pointsEarned;
  final DateTime updatedAt;

  EcoActivity({
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

  bool get isRecent => DateTime.now().difference(performedAt).inHours <= 24;
  bool get isHighImpact => impactValue > 10.0;
}
