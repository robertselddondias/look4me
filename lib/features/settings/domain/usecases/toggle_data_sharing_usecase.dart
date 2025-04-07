import '../repositories/settings_repository.dart';

class ToggleDataSharingUseCase {
  final SettingsRepository repository;

  ToggleDataSharingUseCase(this.repository);

  Future<void> execute({required String userId, required bool enabled}) {
    return repository.toggleDataSharing(
      userId: userId,
      enabled: enabled,
    );
  }
}
