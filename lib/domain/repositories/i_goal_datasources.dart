import 'package:ecosteps/data/dtos/sustainable_goal_dto.dart';

abstract class ISustainableGoalRemoteDatasource {
  Future<List<SustainableGoalDto>> getGoalsSince(DateTime? lastSync);
  Future<SustainableGoalDto> saveGoal(SustainableGoalDto dto);
  Future<void> deleteGoal(int id);
}

abstract class ISustainableGoalLocalDatasource {
  Future<List<SustainableGoalDto>> getCachedGoals();
  Future<void> cacheGoals(List<SustainableGoalDto> dtos); // "upsertAll"
  Future<void> clearGoals(); // "clear"
  Future<DateTime?> getLastGoalSync();
  Future<void> saveLastGoalSync(DateTime time);
}
