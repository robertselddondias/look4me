import 'package:look4me/modules/auth/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  /// Obtém os dados do perfil do usuário atual do servidor
  Future<UserModel> getUserProfile();

  /// Atualiza o perfil do usuário no servidor
  Future<void> updateUserProfile(UserModel user);
}
