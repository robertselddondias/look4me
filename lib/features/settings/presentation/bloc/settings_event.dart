import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserSettingsEvent extends SettingsEvent {
  final String userId;

  const GetUserSettingsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateNotificationSettingsEvent extends SettingsEvent {
  final String userId;
  final bool receiveVoteNotifications;
  final bool receiveFollowerNotifications;
  final bool receiveCommentNotifications;
  final bool receiveStoryNotifications;

  const UpdateNotificationSettingsEvent({
    required this.userId,
    required this.receiveVoteNotifications,
    required this.receiveFollowerNotifications,
    required this.receiveCommentNotifications,
    required this.receiveStoryNotifications,
  });

  @override
  List<Object> get props => [
    userId,
    receiveVoteNotifications,
    receiveFollowerNotifications,
    receiveCommentNotifications,
    receiveStoryNotifications
  ];
}

class UpdatePrivacySettingsEvent extends SettingsEvent {
  final String userId;
  final bool isPrivateProfile;
  final bool showLocationData;
  final String contactDiscoveryOption;

  const UpdatePrivacySettingsEvent({
    required this.userId,
    required this.isPrivateProfile,
    required this.showLocationData,
    required this.contactDiscoveryOption,
  });

  @override
  List<Object> get props => [
    userId,
    isPrivateProfile,
    showLocationData,
    contactDiscoveryOption
  ];
}

class UpdateAppearanceSettingsEvent extends SettingsEvent {
  final String userId;
  final String themeMode;
  final String accentColor;
  final double fontScale;

  const UpdateAppearanceSettingsEvent({
    required this.userId,
    required this.themeMode,
    required this.accentColor,
    required this.fontScale,
  });

  @override
  List<Object> get props => [
    userId,
    themeMode,
    accentColor,
    fontScale
  ];
}

class ToggleDataSharingEvent extends SettingsEvent {
  final String userId;
  final bool enabled;

  const ToggleDataSharingEvent({
    required this.userId,
    required this.enabled,
  });

  @override
  List<Object> get props => [userId, enabled];
}
