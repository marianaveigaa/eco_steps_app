import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'services/prefs_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart'; // Importe o controller novo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('Configure SUPABASE no arquivo .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  await PrefsService.init();

  // 1. Cria e carrega o tema (Etapa 6 da apostila)
  final themeController = ThemeController();
  await themeController.loadTheme();

  // 2. Passa o controller para o app
  runApp(EcoStepsApp(themeController: themeController));
}

class EcoStepsApp extends StatelessWidget {
  final ThemeController themeController;

  const EcoStepsApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    // 3. Usa ListenableBuilder para reconstruir o app quando o tema mudar (Etapa 5)
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'EcoSteps',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Aqui a mágica acontece: o modo agora vem do controller
          themeMode: themeController.themeMode,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
