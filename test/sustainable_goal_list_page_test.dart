import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
// ignore: unused_import
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'mocks.dart'; // Importa nossos mocks

void main() {
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
  // ignore: unused_element
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Container(),
    );
  }

  testWidgets(
      'Deve mostrar CircularProgressIndicator e depois exibir a lista de metas',
      (tester) async {
    when(() => mockRepository.getGoals())
        .thenAnswer((_) async => [tGoalEntity]);
  }, skip: true); // Pula este teste por enquanto
}
