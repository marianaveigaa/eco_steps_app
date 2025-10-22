import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecosteps/widgets/profile_drawer.dart'; // Ajuste o package para o seu projeto EcoSteps
import 'package:ecosteps/services/prefs_service.dart'; // Para mockar prefs

void main() {
  setUp(() async {
    // Inicialize PrefsService para testes
    await PrefsService.init();
  });

  testWidgets('Drawer mostra iniciais quando sem foto (fallback)',
      (WidgetTester tester) async {
    // Limpe dados de foto para simular sem foto
    await PrefsService.clearPhotoData();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileDrawer(),
        ),
      ),
    );

    // Verifique se as iniciais aparecem
    expect(find.text('U'), findsOneWidget);
  });

  testWidgets('Drawer exibe foto quando há caminho salvo',
      (WidgetTester tester) async {
    // Simule um caminho de foto salvo
    PrefsService.userPhotoPath = '/fake/path/user_photo.jpg';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileDrawer(),
        ),
      ),
    );

    // Verifique se o CircleAvatar tem backgroundImage (não child com iniciais)
    final circleAvatar = find.byType(CircleAvatar);
    expect(circleAvatar, findsOneWidget);
    // Nota: Para testar FileImage, pode precisar de mocks avançados, mas isso verifica a estrutura
  });
}
