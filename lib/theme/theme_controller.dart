import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class ThemeController extends ChangeNotifier {
  // Singleton para facilitar o acesso
  static final ThemeController instance = ThemeController._internal();
  factory ThemeController() => instance;
  ThemeController._internal();

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final savedTheme = PrefsService.getThemeMode();
    // AQUI ESTAVA O ERRO: Agora usamos blocos { }
    if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    // AQUI TAMBÉM: Usando chaves para evitar reclamação do linter
    if (isDark) {
      _themeMode = ThemeMode.dark;
      await PrefsService.saveThemeMode('dark');
    } else {
      _themeMode = ThemeMode.light;
      await PrefsService.saveThemeMode('light');
    }
    notifyListeners();
  }
}
