import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> cacheAppearanceSettings({
    required String themeMode,
    required String accentColor,
    required double fontScale,
  });

  Future<Map<String, dynamic>> getAppearanceSettings();
}
