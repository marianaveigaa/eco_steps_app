import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  late final SharedPreferences _prefs;

  // Chaves para evitar erros de digitação
  static const String _policiesVersionKey = 'policies_version_accepted';
  static const String _onboardingKey = 'onboarding_completed';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Verifica se o usuário já tem uma versão das políticas aceita
  String? getAcceptedPoliciesVersion() => _prefs.getString(_policiesVersionKey);

  // Salva a versão da política aceita
  Future<void> acceptPolicies(String version) =>
      _prefs.setString(_policiesVersionKey, version);

  // Remove o aceite (para a função de revogação)
  Future<void> revokeAcceptance() => _prefs.remove(_policiesVersionKey);

  // (Opcional, mas útil) Gerencia se o onboarding foi visto
  bool isOnboardingCompleted() => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setBool(_onboardingKey, value);
}
