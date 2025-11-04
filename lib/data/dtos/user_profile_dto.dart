class UserProfileDto {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalPoints;
  final int currentStreak;
  final String memberSince;
  final String level;
  final String updatedAt;

  UserProfileDto({
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

  factory UserProfileDto.fromMap(Map<String, dynamic> map) => UserProfileDto(
        id: map['id'] as int,
        name: map['name'] as String,
        email: map['email'] as String,
        avatarUrl: map['avatar_url'] as String?,
        totalPoints: map['total_points'] as int,
        currentStreak: map['current_streak'] as int,
        memberSince: map['member_since'] as String,
        level: map['level'] as String,
        updatedAt: map['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'total_points': totalPoints,
        'current_streak': currentStreak,
        'member_since': memberSince,
        'level': level,
        'updated_at': updatedAt,
      };
}
