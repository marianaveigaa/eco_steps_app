import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Chaves
  static const String _privacyRead = 'privacy_read_v1';
  static const String _termsRead = 'terms_read_v1';
  static const String _policiesVersionAccepted = 'policies_version_accepted';
  static const String _acceptedAt = 'accepted_at';
  static const String _onboardingCompleted = 'onboarding_completed';
  static const String _tipsEnabled = 'tips_enabled';

  // Métodos
  static bool isPolicyAccepted(String version) {
    return _prefs.getString(_policiesVersionAccepted) == version;
  }

  static Future<void> acceptPolicies(String version) async {
    await _prefs.setBool(_privacyRead, true);
    await _prefs.setBool(_termsRead, true);
    await _prefs.setString(_policiesVersionAccepted, version);
    await _prefs.setString(_acceptedAt, DateTime.now().toIso8601String());
    await _prefs.setBool(_onboardingCompleted, true);
  }

  static Future<void> revokeAcceptance() async {
    await _prefs.remove(_privacyRead);
    await _prefs.remove(_termsRead);
    await _prefs.remove(_policiesVersionAccepted);
    await _prefs.remove(_acceptedAt);
    await _prefs.setBool(_onboardingCompleted, false);
  }

  static bool get privacyRead => _prefs.getBool(_privacyRead) ?? false;
  static bool get termsRead => _prefs.getBool(_termsRead) ?? false;
  static String? get acceptedVersion =>
      _prefs.getString(_policiesVersionAccepted);
  static String? get acceptedAt => _prefs.getString(_acceptedAt);
  static bool get onboardingCompleted =>
      _prefs.getBool(_onboardingCompleted) ?? false;
  static bool get tipsEnabled => _prefs.getBool(_tipsEnabled) ?? true;
  static set tipsEnabled(bool value) => _prefs.setBool(_tipsEnabled, value);
}
