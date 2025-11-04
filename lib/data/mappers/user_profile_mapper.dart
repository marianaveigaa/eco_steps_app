import '../dtos/user_profile_dto.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileMapper {
  static UserProfile toEntity(UserProfileDto dto) {
    return UserProfile(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      avatarUrl: dto.avatarUrl,
      totalPoints: dto.totalPoints,
      currentStreak: dto.currentStreak,
      memberSince: DateTime.parse(dto.memberSince),
      level: dto.level,
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
