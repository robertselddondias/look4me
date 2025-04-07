// lib/features/settings/di/settings_injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look4me/core/di/app_dependencies.dart';
import 'package:look4me/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:look4me/features/settings/data/datasources/settings_local_datasource_impl.dart';
import 'package:look4me/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:look4me/features/settings/data/datasources/settings_remote_datasource_impl.dart';
import 'package:look4me/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:look4me/features/settings/domain/repositories/settings_repository.dart';
import 'package:look4me/features/settings/domain/usecases/get_user_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/toggle_data_sharing_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_appearance_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_notification_settings_usecase.dart';
import 'package:look4me/features/settings/domain/usecases/update_privacy_settings_usecase.dart';
import 'package:look4me/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> initSettingsDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  // Bloc - registrar o bloc é o mais importante!
  locator.registerFactory(() => SettingsBloc(
    getUserSettings: locator(),
    updateNotificationSettings: locator(),
    updatePrivacySettings: locator(),
    updateAppearanceSettings: locator(),
    toggleDataSharing: locator(),
  ));

  // Use Cases
  locator.registerLazySingleton(() => GetUserSettingsUseCase(locator()));
  locator.registerLazySingleton(() => UpdateNotificationSettingsUseCase(locator()));
  locator.registerLazySingleton(() => UpdatePrivacySettingsUseCase(locator()));
  locator.registerLazySingleton(() => UpdateAppearanceSettingsUseCase(locator()));
  locator.registerLazySingleton(() => ToggleDataSharingUseCase(locator()));

  // Repository
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
    remoteDataSource: locator(),
    localDataSource: locator(),
  ));

  // Data Sources
  locator.registerLazySingleton<SettingsRemoteDataSource>(() => SettingsRemoteDataSourceImpl(
    firestore: locator(),
  ));

  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(
    prefs: locator(),
  ));

  // Firebase
  if (!locator.isRegistered<FirebaseFirestore>()) {
    locator.registerLazySingleton(() => FirebaseFirestore.instance);
  }
}
