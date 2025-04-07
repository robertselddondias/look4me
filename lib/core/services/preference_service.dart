// lib/core/services/preference_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _firstTimeKey = 'first_time';
  static const String _userLoggedInKey = 'user_logged_in';

  // Verifica se é a primeira vez que o usuário abre o app
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  // Marca que não é mais a primeira vez
  static Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
    print("Marcado como não primeira vez");
  }

  // Marca o usuário como logado (pode ser útil para verificações adicionais)
  static Future<void> setUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, value);
    print("Status de login do usuário: $value");
  }

  // Verifica se o usuário está logado (útil para logs e depuração)
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey) ?? false;
  }

  // Limpa todas as preferências (útil para logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    // Preservamos o status de primeira vez ao fazer logout
    final isFirstTime = await PreferenceService.isFirstTime();
    await prefs.clear();

    // Restauramos o status de primeira vez
    if (!isFirstTime) {
      await prefs.setBool(_firstTimeKey, false);
    }

    print("Preferências foram limpas (exceto onboarding)");
  }
}
