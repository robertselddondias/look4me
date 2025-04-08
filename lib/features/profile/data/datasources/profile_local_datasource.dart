import 'package:look4me/modules/auth/models/user_model.dart';

abstract class ProfileLocalDataSource {
  /// Obtém o perfil do usuário armazenado localmente
  Future<UserModel?> getLastUserProfile();

  /// Salva o perfil do usuário localmente
  Future<void> cacheUserProfile(UserModel user);
}
