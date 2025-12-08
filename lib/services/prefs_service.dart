import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- POLÍTICAS E ONBOARDING ---
  static bool isPolicyAccepted(String version) {
    return _prefs.getString('policies_version_accepted') == version;
  }

  static Future<void> acceptPolicies(String version) async {
    await _prefs.setBool('privacy_read_v1', true);
    await _prefs.setBool('terms_read_v1', true);
    await _prefs.setString('policies_version_accepted', version);
    await _prefs.setString('accepted_at', DateTime.now().toIso8601String());
    await _prefs.setBool('onboarding_completed', true);
  }

  static Future<void> revokeAcceptance() async {
    await _prefs.remove('privacy_read_v1');
    await _prefs.remove('terms_read_v1');
    await _prefs.remove('policies_version_accepted');
    await _prefs.remove('accepted_at');
    await _prefs.setBool('onboarding_completed', false);
  }

  static bool get privacyRead => _prefs.getBool('privacy_read_v1') ?? false;
  static bool get termsRead => _prefs.getBool('terms_read_v1') ?? false;
  static String? get acceptedVersion =>
      _prefs.getString('policies_version_accepted');
  static String? get acceptedAt => _prefs.getString('accepted_at');
  static bool get onboardingCompleted =>
      _prefs.getBool('onboarding_completed') ?? false;

  // --- CONFIGURAÇÕES GERAIS ---
  static bool get tipsEnabled => _prefs.getBool('tips_enabled') ?? true;
  static set tipsEnabled(bool value) => _prefs.setBool('tips_enabled', value);

  // --- NOME DO USUÁRIO (NOVO) ---
  static String get userName => _prefs.getString('userName') ?? 'Usuário';
  static set userName(String value) => _prefs.setString('userName', value);

  // --- FOTO DE PERFIL ---
  static String? get userPhotoPath => _prefs.getString('userPhotoPath');
  static set userPhotoPath(String? value) =>
      _prefs.setString('userPhotoPath', value ?? '');

  static DateTime? get userPhotoUpdatedAt {
    final timestamp = _prefs.getInt('userPhotoUpdatedAt');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  static set userPhotoUpdatedAt(DateTime? value) {
    _prefs.setInt('userPhotoUpdatedAt', value?.millisecondsSinceEpoch ?? 0);
  }

  static Future<void> clearPhotoData() async {
    await _prefs.remove('userPhotoPath');
    await _prefs.remove('userPhotoUpdatedAt');
  }

  // --- TEMA ESCURO/CLARO ---
  // Salva a escolha do usuário: 'light', 'dark' ou 'system'
  static Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString('theme_mode', themeMode);
  }

  // Recupera o tema salvo (padrão é 'system')
  static String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'system';
  }
}
