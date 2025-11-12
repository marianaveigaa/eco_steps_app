import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/data/dtos/sustainable_goal_dto.dart';
import 'package:ecosteps/data/repositories/sustainable_goal_repository.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
// ignore: unused_import
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'mocks.dart';

void main() {
  late SustainableGoalRepository repository;
  late MockGoalRemoteDatasource mockRemote;
  late MockGoalLocalDatasource mockLocal;

  // DTO de exemplo
  final tGoalDto = SustainableGoalDto(
    id: 1,
    title: 'Test DTO',
    description: '',
    category: 'lixo',
    targetValue: 10,
    currentValue: 5,
    unit: 'kg',
    deadline: DateTime.now().toIso8601String(),
    completed: false,
    updatedAt: DateTime.now().toIso8601String(),
  );

  // Entidade de exemplo
  final tGoalEntity = SustainableGoal(
    id: 1,
    title: 'Test DTO',
    description: '',
    category: 'lixo',
    targetValue: 10,
    currentValue: 5,
    unit: 'kg',
    deadline: DateTime.parse(tGoalDto.deadline),
    completed: false,
    updatedAt: DateTime.parse(tGoalDto.updatedAt),
  );

  setUp(() {
    registerFallbackValues();
    mockRemote = MockGoalRemoteDatasource();
    mockLocal = MockGoalLocalDatasource();
    repository = SustainableGoalRepository(
      remote: mockRemote,
      local: mockLocal,
    );
  });

  group('getGoals (Unit Test)', () {
    test(
        'Deve (1) buscar no remoto, (2) salvar no cache, e (3) retornar dados do cache',
        () async {
      // ARRANGE (Configura os mocks)
      when(() => mockLocal.getLastGoalSync()).thenAnswer((_) async => null);
      when(() => mockRemote.getGoalsSince(null))
          .thenAnswer((_) async => [tGoalDto]);
      when(() => mockLocal.cacheGoals(any())).thenAnswer((_) async {});
      when(() => mockLocal.saveLastGoalSync(any())).thenAnswer((_) async {});
      when(() => mockLocal.getCachedGoals())
          .thenAnswer((_) async => [tGoalDto]);

      // ACT (Chama o método)
      final result = await repository.getGoals();

      // ASSERT (Verifica o resultado)
      expect(result.first.title, tGoalEntity.title);
      verifyInOrder([
        () => mockLocal.getLastGoalSync(),
        () => mockRemote.getGoalsSince(null),
        () => mockLocal.cacheGoals([tGoalDto]),
        () => mockLocal.saveLastGoalSync(any()),
        () => mockLocal.getCachedGoals(),
      ]);
    });

    test('Deve retornar dados do cache (offline-first) se a rede falhar',
        () async {
      // ARRANGE
      when(() => mockLocal.getLastGoalSync()).thenAnswer((_) async => null);
      when(() => mockRemote.getGoalsSince(null))
          .thenThrow(Exception('Falha de rede'));
      when(() => mockLocal.getCachedGoals())
          .thenAnswer((_) async => [tGoalDto]);

      // ACT
      final result = await repository.getGoals();

      // ASSERT
      expect(result.first.id, tGoalEntity.id);
      verifyNever(() => mockLocal.cacheGoals(any()));
    });
  });
}
