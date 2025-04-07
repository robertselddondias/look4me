import '../repositories/settings_repository.dart';

class UpdateNotificationSettingsUseCase {
  final SettingsRepository repository;

  UpdateNotificationSettingsUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required bool receiveVoteNotifications,
    required bool receiveFollowerNotifications,
    required bool receiveCommentNotifications,
    required bool receiveStoryNotifications,
  }) {
    return repository.updateNotificationSettings(
      userId: userId,
      receiveVoteNotifications: receiveVoteNotifications,
      receiveFollowerNotifications: receiveFollowerNotifications,
      receiveCommentNotifications: receiveCommentNotifications,
      receiveStoryNotifications: receiveStoryNotifications,
    );
  }
}
