import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/data/dtos/sustainable_goal_dto.dart';
import 'package:ecosteps/data/repositories/sustainable_goal_repository.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'mocks.dart'; // Importa nossos mocks

void main() {
  late SustainableGoalRepository repository;
  late MockGoalRemoteDatasource mockRemote;
  late MockGoalLocalDatasource mockLocal;

  // Um DTO de exemplo que vem do Supabase/Cache
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

  // Uma Entidade de exemplo que vai para a UI
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
    // Configuração inicial para cada teste
    registerFallbackValues(); // Registra os fallbacks
    mockRemote = MockGoalRemoteDatasource();
    mockLocal = MockGoalLocalDatasource();
    repository = SustainableGoalRepository(
      remote: mockRemote,
      local: mockLocal,
    );
  });

  group('getGoals', () {
    test('Deve retornar dados do cache após sincronizar com o remoto',
        () async {
      // ARRANGE (Configura os mocks)
      // 1. Simula o "getLastGoalSync" retornando null (primeira vez)
      when(() => mockLocal.getLastGoalSync()).thenAnswer((_) async => null);
      // 2. Simula o "getGoalsSince" (remoto) retornando nosso DTO
      when(() => mockRemote.getGoalsSince(null))
          .thenAnswer((_) async => [tGoalDto]);
      // 3. Simula o "cacheGoals" (local) não fazendo nada
      when(() => mockLocal.cacheGoals(any())).thenAnswer((_) async {
        return null;
      });
      // 4. Simula o "saveLastGoalSync" (local) não fazendo nada
      when(() => mockLocal.saveLastGoalSync(any())).thenAnswer((_) async {
        return null;
      });
      // 5. Simula o "getCachedGoals" (local) retornando o DTO
      when(() => mockLocal.getCachedGoals())
          .thenAnswer((_) async => [tGoalDto]);

      // ACT (Chama o método)
      final result = await repository.getGoals();

      // ASSERT (Verifica o resultado)
      // Espera que o resultado seja uma Lista de SustainableGoal
      expect(result, isA<List<SustainableGoal>>());
      expect(result.first.title, tGoalEntity.title);

      // Verifica se os métodos corretos foram chamados NA ORDEM CORRETA
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
      // 1. Simula o "getLastGoalSync"
      when(() => mockLocal.getLastGoalSync()).thenAnswer((_) async => null);
      // 2. Simula a REDE FALHANDO
      when(() => mockRemote.getGoalsSince(null))
          .thenThrow(Exception('Falha de rede'));
      // 3. Simula o CACHE tendo dados
      when(() => mockLocal.getCachedGoals())
          .thenAnswer((_) async => [tGoalDto]);

      // ACT
      final result = await repository.getGoals();

      // ASSERT
      // O resultado DEVE ser a lista do cache
      expect(result, isA<List<SustainableGoal>>());
      expect(result.first.id, tGoalEntity.id);

      // Verifica que o 'cacheGoals' NUNCA foi chamado
      verifyNever(() => mockLocal.cacheGoals(any()));
    });
  });

  group('saveGoal', () {
    test('Deve salvar no remoto e depois atualizar o cache', () async {
      // ARRANGE
      // 1. Simula o "saveGoal" (remoto) retornando o DTO salvo
      when(() => mockRemote.saveGoal(any())).thenAnswer((_) async => tGoalDto);
      // 2. Simula o "cacheGoals" (local)
      when(() => mockLocal.cacheGoals(any())).thenAnswer((_) async {
        return null;
      });

      // ACT
      await repository.saveGoal(tGoalEntity);

      // ASSERT
      // Verifica se os métodos foram chamados na ordem correta
      verifyInOrder([
        () => mockRemote.saveGoal(any(that: isA<SustainableGoalDto>())),
        () => mockLocal.cacheGoals([tGoalDto]),
      ]);
    });
  });
}
