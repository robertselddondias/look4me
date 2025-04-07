import 'package:look4me/features/settings/domain/repositories/settings_repository.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

class GetUserSettingsUseCase {
  final SettingsRepository repository;

  GetUserSettingsUseCase(this.repository);

  Future<UserModel> execute(String userId) {
    return repository.getUserSettings(userId);
  }
}
