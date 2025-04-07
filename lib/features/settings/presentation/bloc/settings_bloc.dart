import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_settings_usecase.dart';
import '../../domain/usecases/update_notification_settings_usecase.dart';
import '../../domain/usecases/update_privacy_settings_usecase.dart';
import '../../domain/usecases/update_appearance_settings_usecase.dart';
import '../../domain/usecases/toggle_data_sharing_usecase.dart';
import './settings_event.dart';
import './settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetUserSettingsUseCase _getUserSettings;
  final UpdateNotificationSettingsUseCase _updateNotificationSettings;
  final UpdatePrivacySettingsUseCase _updatePrivacySettings;
  final UpdateAppearanceSettingsUseCase _updateAppearanceSettings;
  final ToggleDataSharingUseCase _toggleDataSharing;

  SettingsBloc({
    required GetUserSettingsUseCase getUserSettings,
    required UpdateNotificationSettingsUseCase updateNotificationSettings,
    required UpdatePrivacySettingsUseCase updatePrivacySettings,
    required UpdateAppearanceSettingsUseCase updateAppearanceSettings,
    required ToggleDataSharingUseCase toggleDataSharing,
  }) :
        _getUserSettings = getUserSettings,
        _updateNotificationSettings = updateNotificationSettings,
        _updatePrivacySettings = updatePrivacySettings,
        _updateAppearanceSettings = updateAppearanceSettings,
        _toggleDataSharing = toggleDataSharing,
        super(SettingsInitial()) {
    on<GetUserSettingsEvent>(_onGetUserSettings);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<UpdatePrivacySettingsEvent>(_onUpdatePrivacySettings);
    on<UpdateAppearanceSettingsEvent>(_onUpdateAppearanceSettings);
    on<ToggleDataSharingEvent>(_onToggleDataSharing);
  }

  Future<void> _onGetUserSettings(
      GetUserSettingsEvent event,
      Emitter<SettingsState> emit
      ) async {
    emit(SettingsLoading());
    try {
      final user = await _getUserSettings.execute(event.userId);
      emit(SettingsLoaded(user: user));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNotificationSettings(
      UpdateNotificationSettingsEvent event,
      Emitter<SettingsState> emit
      ) async {
    emit(SettingsLoading());
    try {
      await _updateNotificationSettings.execute(
        userId: event.userId,
        receiveVoteNotifications: event.receiveVoteNotifications,
        receiveFollowerNotifications: event.receiveFollowerNotifications,
        receiveCommentNotifications: event.receiveCommentNotifications,
        receiveStoryNotifications: event.receiveStoryNotifications,
      );
      emit(NotificationSettingsUpdated());

      // Recarregar as configurações atualizadas
      final user = await _getUserSettings.execute(event.userId);
      emit(SettingsLoaded(user: user));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePrivacySettings(
      UpdatePrivacySettingsEvent event,
      Emitter<SettingsState> emit
      ) async {
    emit(SettingsLoading());
    try {
      await _updatePrivacySettings.execute(
        userId: event.userId,
        isPrivateProfile: event.isPrivateProfile,
        showLocationData: event.showLocationData,
        contactDiscoveryOption: event.contactDiscoveryOption,
      );
      emit(PrivacySettingsUpdated());

      // Recarregar as configurações atualizadas
      final user = await _getUserSettings.execute(event.userId);
      emit(SettingsLoaded(user: user));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateAppearanceSettings(
      UpdateAppearanceSettingsEvent event,
      Emitter<SettingsState> emit
      ) async {
    emit(SettingsLoading());
    try {
      await _updateAppearanceSettings.execute(
        userId: event.userId,
        themeMode: event.themeMode,
        accentColor: event.accentColor,
        fontScale: event.fontScale,
      );
      emit(AppearanceSettingsUpdated());

      // Recarregar as configurações atualizadas
      final user = await _getUserSettings.execute(event.userId);
      emit(SettingsLoaded(user: user));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onToggleDataSharing(
      ToggleDataSharingEvent event,
      Emitter<SettingsState> emit
      ) async {
    emit(SettingsLoading());
    try {
      await _toggleDataSharing.execute(
        userId: event.userId,
        enabled: event.enabled,
      );
      emit(DataSharingUpdated());

      // Recarregar as configurações atualizadas
      final user = await _getUserSettings.execute(event.userId);
      emit(SettingsLoaded(user: user));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}
