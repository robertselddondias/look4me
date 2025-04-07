import 'package:look4me/modules/auth/models/user_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserModel> getUserSettings(String userId);

  Future<void> updateNotificationSettings({
    required String userId,
    required bool receiveVoteNotifications,
    required bool receiveFollowerNotifications,
    required bool receiveCommentNotifications,
    required bool receiveStoryNotifications,
  });

  Future<void> updatePrivacySettings({
    required String userId,
    required bool isPrivateProfile,
    required bool showLocationData,
    required String contactDiscoveryOption,
  });

  Future<void> updateAppearanceSettings({
    required String userId,
    required String themeMode,
    required String accentColor,
    required double fontScale,
  });

  Future<void> toggleDataSharing({
    required String userId,
    required bool enabled,
  });
}
