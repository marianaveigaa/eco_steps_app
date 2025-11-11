import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';

// 1. Mock do Repositório (para o Widget Test)
//    Simula o ISustainableGoalRepository
class MockSustainableGoalRepository extends Mock
    implements ISustainableGoalRepository {}

// 2. Mock dos Datasources (para o Unit Test)
//    Simula o ISustainableGoalRemoteDatasource (Supabase)
class MockGoalRemoteDatasource extends Mock
    implements ISustainableGoalRemoteDatasource {}

//    Simula o ISustainableGoalLocalDatasource (Cache)
class MockGoalLocalDatasource extends Mock
    implements ISustainableGoalLocalDatasource {}

// 3. Fallback/Matcher (necessário para o mocktail)
//    Isso é necessário para o mocktail funcionar com
//    parâmetros de tipo SustainableGoal
class FakeSustainableGoal extends Fake implements SustainableGoal {}

void registerFallbackValues() {
  registerFallbackValue(FakeSustainableGoal());
}
