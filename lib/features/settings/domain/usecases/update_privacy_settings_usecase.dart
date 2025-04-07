import '../repositories/settings_repository.dart';

class UpdatePrivacySettingsUseCase {
  final SettingsRepository repository;

  UpdatePrivacySettingsUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required bool isPrivateProfile,
    required bool showLocationData,
    required String contactDiscoveryOption,
  }) {
    return repository.updatePrivacySettings(
      userId: userId,
      isPrivateProfile: isPrivateProfile,
      showLocationData: showLocationData,
      contactDiscoveryOption: contactDiscoveryOption,
    );
  }
}
