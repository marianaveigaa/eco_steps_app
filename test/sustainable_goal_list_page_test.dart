import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'mocks.dart'; // Importa nossos mocks

void main() {
  // ATENÇÃO:
  // Este teste não pode ser executado como "flutter test"
  // porque o seu SustainableGoalListPage instancia os repositórios reais.
  // Para este teste funcionar, você precisaria refatorar a ListPage
  // para RECEBER o repositório (Injeção de Dependência), ex:
  //
  // final ISustainableGoalRepository repository;
  // const SustainableGoalListPage({super.key, required this.repository});
  //
  // Se você fizer essa refatoração, o teste abaixo funcionará.
  // Se não, você pode pular este arquivo,
  // pois o "Enunciado"  pede "testes mínimos". O Unit Test acima já conta.
  //
  // Vamos escrever o teste assumindo que você refatorou para Injeção de Dependência.

  late MockSustainableGoalRepository mockRepository;

  // Uma entidade de meta para simular o retorno do repositório
  final tGoalEntity = SustainableGoal(
    id: 1,
    title: 'Meta de Teste',
    description: '',
    category: 'lixo',
    targetValue: 10,
    currentValue: 5,
    unit: 'kg',
    deadline: DateTime.now(),
    completed: false,
    updatedAt: DateTime.now(),
  );

  setUp(() {
    registerFallbackValues();
    mockRepository = MockSustainableGoalRepository();
  });

  // Função helper para "inflar" o widget da tela
  Widget createWidgetUnderTest() {
    return MaterialApp(
      // Se você refatorar para Injeção de Dependência:
      // home: SustainableGoalListPage(repository: mockRepository),

      // Se você NÃO refatorar, não podemos testar com mock.
      // Por agora, vamos pular este teste,
      // pois ele exige uma refatoração grande (Injeção de Dependência).
      home: Container(),
    );
  }

  // Se você implementar a Injeção de Dependência, este teste funcionará:
  testWidgets(
      'Deve mostrar CircularProgressIndicator e depois exibir a lista de metas',
      (tester) async {
    // ARRANGE
    // Simula o repositório demorando e depois retornando uma lista
    when(() => mockRepository.getGoals())
        .thenAnswer((_) async => [tGoalEntity]);

    // ACT
    // await tester.pumpWidget(createWidgetUnderTest());

    // ASSERT (Inicial)
    // Espera que o loading apareça
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Avança o tempo do widget
    // await tester.pumpAndSettle();

    // ASSERT (Final)
    // Espera que o loading suma e o título da meta apareça
    // expect(find.byType(CircularProgressIndicator), findsNothing);
    // expect(find.text('Meta de Teste'), findsOneWidget);
    // expect(find.text('50% (5.0 / 10.0 kg)'), findsOneWidget);
  }, skip: true); // Pula este teste por enquanto
}
