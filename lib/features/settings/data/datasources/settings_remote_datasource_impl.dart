import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look4me/modules/auth/models/user_model.dart';
import './settings_remote_datasource.dart';

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final FirebaseFirestore _firestore;

  SettingsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<UserModel> getUserSettings(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('Usuário não encontrado');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw Exception('Erro ao obter configurações do usuário: $e');
    }
  }

  @override
  Future<void> updateNotificationSettings({
    required String userId,
    required bool receiveVoteNotifications,
    required bool receiveFollowerNotifications,
    required bool receiveCommentNotifications,
    required bool receiveStoryNotifications,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'receiveVoteNotifications': receiveVoteNotifications,
        'receiveFollowerNotifications': receiveFollowerNotifications,
        'receiveCommentNotifications': receiveCommentNotifications,
        'receiveStoryNotifications': receiveStoryNotifications,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar configurações de notificação: $e');
    }
  }

  @override
  Future<void> updatePrivacySettings({
    required String userId,
    required bool isPrivateProfile,
    required bool showLocationData,
    required String contactDiscoveryOption,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isPrivateProfile': isPrivateProfile,
        'showLocationData': showLocationData,
        'contactDiscoveryOption': contactDiscoveryOption,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar configurações de privacidade: $e');
    }
  }

  @override
  Future<void> updateAppearanceSettings({
    required String userId,
    required String themeMode,
    required String accentColor,
    required double fontScale,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'themeMode': themeMode,
        'accentColor': accentColor,
        'fontScale': fontScale,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar configurações de aparência: $e');
    }
  }

  @override
  Future<void> toggleDataSharing({
    required String userId,
    required bool enabled,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'dataSharingEnabled': enabled,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar compartilhamento de dados: $e');
    }
  }
}
