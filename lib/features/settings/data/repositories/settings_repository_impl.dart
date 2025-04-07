import 'package:look4me/modules/auth/models/user_model.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl({
    required SettingsRemoteDataSource remoteDataSource,
    required SettingsLocalDataSource localDataSource,
  }) :
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserModel> getUserSettings(String userId) async {
    return await _remoteDataSource.getUserSettings(userId);
  }

  @override
  Future<void> updateNotificationSettings({
    required String userId,
    required bool receiveVoteNotifications,
    required bool receiveFollowerNotifications,
    required bool receiveCommentNotifications,
    required bool receiveStoryNotifications,
  }) async {
    await _remoteDataSource.updateNotificationSettings(
      userId: userId,
      receiveVoteNotifications: receiveVoteNotifications,
      receiveFollowerNotifications: receiveFollowerNotifications,
      receiveCommentNotifications: receiveCommentNotifications,
      receiveStoryNotifications: receiveStoryNotifications,
    );
  }

  @override
  Future<void> updatePrivacySettings({
    required String userId,
    required bool isPrivateProfile,
    required bool showLocationData,
    required String contactDiscoveryOption,
  }) async {
    await _remoteDataSource.updatePrivacySettings(
      userId: userId,
      isPrivateProfile: isPrivateProfile,
      showLocationData: showLocationData,
      contactDiscoveryOption: contactDiscoveryOption,
    );
  }

  @override
  Future<void> updateAppearanceSettings({
    required String userId,
    required String themeMode,
    required String accentColor,
    required double fontScale,
  }) async {
    // Atualizar tanto no Firebase quanto no cache local
    await _remoteDataSource.updateAppearanceSettings(
      userId: userId,
      themeMode: themeMode,
      accentColor: accentColor,
      fontScale: fontScale,
    );

    await _localDataSource.cacheAppearanceSettings(
      themeMode: themeMode,
      accentColor: accentColor,
      fontScale: fontScale,
    );
  }

  @override
  Future<void> toggleDataSharing({
    required String userId,
    required bool enabled,
  }) async {
    await _remoteDataSource.toggleDataSharing(
      userId: userId,
      enabled: enabled,
    );
  }
}
