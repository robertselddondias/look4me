import 'package:look4me/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:look4me/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:look4me/features/profile/domain/repositories/profile_repository.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel> getUserProfile() async {
    try {
      // Tentar obter do servidor
      final userModel = await remoteDataSource.getUserProfile();

      // Salvar localmente para acesso offline
      await localDataSource.cacheUserProfile(userModel);

      return userModel;
    } catch (e) {
      // Se falhar, tenta recuperar do cache local
      try {
        final cachedUser = await localDataSource.getLastUserProfile();
        if (cachedUser != null) {
          return cachedUser;
        }
      } catch (_) {
        // Se não conseguir do cache, propaga o erro original
      }

      throw Exception('Não foi possível obter o perfil do usuário: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      // Atualizar no servidor
      await remoteDataSource.updateUserProfile(user);

      // Atualizar localmente
      await localDataSource.cacheUserProfile(user);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }
}
