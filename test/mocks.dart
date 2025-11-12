import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';

class MockSustainableGoalRepository extends Mock
    implements ISustainableGoalRepository {}

class MockGoalRemoteDatasource extends Mock
    implements ISustainableGoalRemoteDatasource {}

class MockGoalLocalDatasource extends Mock
    implements ISustainableGoalLocalDatasource {}

class FakeSustainableGoal extends Fake implements SustainableGoal {}

void registerFallbackValues() {
  registerFallbackValue(FakeSustainableGoal());
}
