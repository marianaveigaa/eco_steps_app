import 'package:ecosteps/domain/entities/sustainable_goal.dart';

// Este é o contrato de domínio que a UI vai usar.
abstract class ISustainableGoalRepository {
  Future<List<SustainableGoal>> getGoals();
  Future<void> saveGoal(SustainableGoal goal);
  Future<void> deleteGoal(SustainableGoal goal);
}
