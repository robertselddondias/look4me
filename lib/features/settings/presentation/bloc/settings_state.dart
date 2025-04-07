import 'package:equatable/equatable.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserModel user;

  const SettingsLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class NotificationSettingsUpdated extends SettingsState {}

class PrivacySettingsUpdated extends SettingsState {}

class AppearanceSettingsUpdated extends SettingsState {}

class DataSharingUpdated extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}
