// lib/features/settings/settings_module.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:look4me/core/di/app_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Data Sources
abstract class SettingsDataSource {
  Future<Map<String, dynamic>> getUserSettings(String userId);
  Future<void> updateSettings(String userId, Map<String, dynamic> settings);
}

class FirebaseSettingsDataSource implements SettingsDataSource {
  final FirebaseFirestore _firestore;

  FirebaseSettingsDataSource(this._firestore);

  @override
  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      return userDoc.data() ?? {};
    } catch (e) {
      throw Exception('Error fetching user settings: $e');
    }
  }

  @override
  Future<void> updateSettings(String userId, Map<String, dynamic> settings) async {
    try {
      await _firestore.collection('users').doc(userId).update(settings);
    } catch (e) {
      throw Exception('Error updating settings: $e');
    }
  }
}

class LocalSettingsDataSource {
  final SharedPreferences _prefs;

  LocalSettingsDataSource(this._prefs);

  Future<void> cacheSettings(Map<String, dynamic> settings) async {
    for (var entry in settings.entries) {
      if (entry.value is String) {
        await _prefs.setString(entry.key, entry.value);
      } else if (entry.value is bool) {
        await _prefs.setBool(entry.key, entry.value);
      } else if (entry.value is double) {
        await _prefs.setDouble(entry.key, entry.value);
      } else if (entry.value is int) {
        await _prefs.setInt(entry.key, entry.value);
      }
    }
  }

  Map<String, dynamic> getCachedSettings() {
    return {
      'theme_mode': _prefs.getString('theme_mode') ?? 'light',
      'accent_color': _prefs.getString('accent_color') ?? 'primary',
      'font_scale': _prefs.getDouble('font_scale') ?? 1.0,
      'notifications_enabled': _prefs.getBool('notifications_enabled') ?? true,
    };
  }
}

// Repository
class SettingsRepository {
  final SettingsDataSource _remoteDataSource;
  final LocalSettingsDataSource _localDataSource;

  SettingsRepository(this._remoteDataSource, this._localDataSource);

  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    try {
      final remoteSettings = await _remoteDataSource.getUserSettings(userId);
      await _localDataSource.cacheSettings(remoteSettings);
      return remoteSettings;
    } catch (e) {
      // Fallback to local cache if remote fetch fails
      return _localDataSource.getCachedSettings();
    }
  }

  Future<void> updateSettings(String userId, Map<String, dynamic> settings) async {
    await _remoteDataSource.updateSettings(userId, settings);
    await _localDataSource.cacheSettings(settings);
  }
}

// Bloc
enum SettingsStatus { initial, loading, success, error }

class SettingsState {
  final SettingsStatus status;
  final Map<String, dynamic> settings;
  final String? errorMessage;

  SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const {},
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    Map<String, dynamic>? settings,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SettingsBloc extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  final String userId;

  SettingsBloc(this._repository, this.userId) : super(SettingsState());

  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));
      final settings = await _repository.getUserSettings(userId);
      emit(state.copyWith(
          status: SettingsStatus.success,
          settings: settings
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString()
      ));
    }
  }

  Future<void> updateSettings(Map<String, dynamic> updates) async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));
      await _repository.updateSettings(userId, updates);

      // Merge updates with existing settings
      final updatedSettings = {...state.settings, ...updates};

      emit(state.copyWith(
          status: SettingsStatus.success,
          settings: updatedSettings
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString()
      ));
    }
  }
}

// Dependency Injection
class SettingsModule {
  static Future<void> init(GetIt getIt) async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    // Register Local Data Source
    getIt.registerLazySingleton<LocalSettingsDataSource>(
            () => LocalSettingsDataSource(getIt<SharedPreferences>())
    );

    // Register Remote Data Source
    getIt.registerLazySingleton<SettingsDataSource>(
            () => FirebaseSettingsDataSource(FirebaseFirestore.instance)
    );

    // Register Repository
    getIt.registerLazySingleton<SettingsRepository>(
            () => SettingsRepository(
            getIt<SettingsDataSource>(),
            getIt<LocalSettingsDataSource>()
        )
    );
  }

  static SettingsBloc createBloc(GetIt getIt, String userId) {
    return SettingsBloc(
        getIt<SettingsRepository>(),
        userId
    );
  }
}

// Usage Example in main.dart or dependency injection setup
void setupDependencies() async {
  // Other dependency initializations...
  await SettingsModule.init(locator);
}
