// lib/features/settings/presentation/bloc/settings_bloc_factory.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look4me/features/settings/data/datasources/settings_local_datasource_impl.dart';
import 'package:look4me/features/settings/data/datasources/settings_remote_datasource_impl.dart';
import 'package:look4me/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:look4me/features/settings/domain/usecases/get_user_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/toggle_data_sharing_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_appearance_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_notification_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_privacy_settings_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/settings_bloc.dart';

class SettingsBlocFactory {

  static late SharedPreferences s;

  static Future<void> initialize() async {
    s = await SharedPreferences.getInstance();
  }

  static SettingsBloc create() {
    final repository = SettingsRepositoryImpl(
      remoteDataSource: SettingsRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      ),
      localDataSource: SettingsLocalDataSourceImpl(
        prefs: s,
      ),
    );

    return SettingsBloc(
      getUserSettings: GetUserSettingsUseCase(repository),
      updateNotificationSettings: UpdateNotificationSettingsUseCase(repository),
      updatePrivacySettings: UpdatePrivacySettingsUseCase(repository),
      updateAppearanceSettings: UpdateAppearanceSettingsUseCase(repository),
      toggleDataSharing: ToggleDataSharingUseCase(repository),
    );
  }
}
