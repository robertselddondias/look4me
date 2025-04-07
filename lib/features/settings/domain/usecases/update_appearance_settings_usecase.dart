import '../repositories/settings_repository.dart';

class UpdateAppearanceSettingsUseCase {
  final SettingsRepository repository;

  UpdateAppearanceSettingsUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required String themeMode,
    required String accentColor,
    required double fontScale,
  }) {
    return repository.updateAppearanceSettings(
      userId: userId,
      themeMode: themeMode,
      accentColor: accentColor,
      fontScale: fontScale,
    );
  }
}
