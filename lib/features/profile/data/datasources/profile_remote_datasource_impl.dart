import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:look4me/modules/auth/models/user_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final currentUser = auth.currentUser;

      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final userDoc = await firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        throw Exception('Perfil de usuário não encontrado');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Erro ao buscar perfil: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      final currentUser = auth.currentUser;

      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      // Se o usuário tentar atualizar o nome de usuário, verificar se já existe
      if (user.username != user.username) {
        final usernameQuery = await firestore
            .collection('users')
            .where('username', isEqualTo: user.username)
            .get();

        if (usernameQuery.docs.isNotEmpty) {
          throw Exception('Este nome de usuário já está em uso');
        }
      }

      // Preparar os dados para atualização (garantindo que todos os campos importantes sejam atualizados)
      final updateData = {
        'fullName': user.fullName,
        'username': user.username,
        'bio': user.bio,
        'photoUrl': user.photoUrl,
        'location': user.location,
        // Garantir que as preferências sejam corretamente atualizadas
        'categories': user.categories,
        'fashionStyle': user.fashionStyle,
        'interests': user.interests,
      };

      // Atualizar no Firestore
      await firestore.collection('users').doc(currentUser.uid).update(updateData);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }
}
