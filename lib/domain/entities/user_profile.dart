class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalPoints;
  final int currentStreak;
  final DateTime memberSince;
  final String level;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.totalPoints,
    required this.currentStreak,
    required this.memberSince,
    required this.level,
    required this.updatedAt,
  });

  double get nextLevelProgress {
    const thresholds = [0, 100, 500, 1000];
    final currentThreshold = thresholds[_getLevelIndex(level)];
    final nextThreshold = thresholds[_getLevelIndex(level) + 1];
    final progress =
        (totalPoints - currentThreshold) / (nextThreshold - currentThreshold);
    return progress.clamp(0.0, 1.0);
  }

  int _getLevelIndex(String level) {
    switch (level) {
      case 'beginner':
        return 0;
      case 'intermediate':
        return 1;
      case 'advanced':
        return 2;
      case 'expert':
        return 3;
      default:
        return 0;
    }
  }
}
