import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecosteps/widgets/profile_drawer.dart';
import 'package:ecosteps/services/prefs_service.dart';

void main() {
  setUp(() async {
    // Inicialize PrefsService para testes
    await PrefsService.init();
  });

  testWidgets('Drawer mostra iniciais quando sem foto (fallback)',
      (WidgetTester tester) async {
    await PrefsService.clearPhotoData();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileDrawer(),
        ),
      ),
    );

    expect(find.text('U'), findsOneWidget);
  });

  testWidgets('Drawer exibe foto quando há caminho salvo',
      (WidgetTester tester) async {
    PrefsService.userPhotoPath = '/fake/path/user_photo.jpg';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileDrawer(),
        ),
      ),
    );

    final circleAvatar = find.byType(CircleAvatar);
    expect(circleAvatar, findsOneWidget);
  });
}
