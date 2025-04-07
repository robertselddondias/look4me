import 'package:shared_preferences/shared_preferences.dart';
import './settings_local_datasource.dart';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheAppearanceSettings({
    required String themeMode,
    required String accentColor,
    required double fontScale,
  }) async {
    await _prefs.setString('theme_mode', themeMode);
    await _prefs.setString('accent_color', accentColor);
    await _prefs.setDouble('font_scale', fontScale);
  }

  @override
  Future<Map<String, dynamic>> getAppearanceSettings() async {
    return {
      'themeMode': _prefs.getString('theme_mode') ?? 'light',
      'accentColor': _prefs.getString('accent_color') ?? 'default',
      'fontScale': _prefs.getDouble('font_scale') ?? 1.0,
    };
  }
}
