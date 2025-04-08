import 'package:look4me/modules/auth/models/user_model.dart';

abstract class ProfileRepository {
  /// Obtém os dados do perfil do usuário atual
  Future<UserModel> getUserProfile();

  /// Atualiza o perfil do usuário
  Future<void> updateUserProfile(UserModel user);
}
