import 'package:get_it/get_it.dart';
import 'package:ecosteps/core/services/prefs_service.dart';

final getIt = GetIt.instance;

// Função para configurar os serviços
Future<void> setupLocator() async {
  final prefsService = PrefsService();
  await prefsService.init(); // Inicializa o SharedPreferences
  getIt.registerSingleton<PrefsService>(prefsService);
}
