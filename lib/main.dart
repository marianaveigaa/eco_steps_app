// lib/main.dart

// MUDANÇA 1: Adicionando o import que faltava para o AppTheme
import 'package:ecosteps/core/app_theme.dart';
import 'package:ecosteps/core/services/service_locator.dart';

// MUDANÇA 2: Corrigindo o 'package.' para 'package:'
import 'package:ecosteps/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  // Garante que os bindings do Flutter estão prontos antes de qualquer coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Configura nossos serviços (PrefsService) antes de rodar o app
  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MUDANÇA 3: Removi os 'prints' que eram apenas para depuração
    return MaterialApp.router(
      title: 'EcoSteps',
      // Reativei o tema para o app ficar com a aparência correta
      theme: AppTheme.lightTheme,
      // O 'router' agora será encontrado pois o import está correto
      routerConfig: router,
    );
  }
}
