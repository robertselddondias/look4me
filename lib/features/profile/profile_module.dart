import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:look4me/features/profile/domain/bloc/profile_bloc.dart';
import 'package:look4me/features/profile/domain/bloc/profile_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:look4me/core/di/app_dependencies.dart';

import 'data/datasources/profile_local_datasource.dart';
import 'data/datasources/profile_local_datasource_impl.dart';
import 'data/datasources/profile_remote_datasource.dart';
import 'data/datasources/profile_remote_datasource_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/pages/edit_profile_page.dart';
import 'presentation/pages/profile_page.dart';

/// Módulo responsável por gerenciar todas as dependências e páginas relacionadas ao perfil de usuário.
class ProfileModule {
  static final GetIt _locator = locator;

  /// Inicializa o módulo de perfil com todas as dependências necessárias.
  /// Deve ser chamado no início da aplicação, após a inicialização do Firebase.
  static Future<void> init() async {
    // Registrar dependências externas se ainda não estiverem registradas
    if (!_locator.isRegistered<FirebaseFirestore>()) {
      _locator.registerLazySingleton<FirebaseFirestore>(
              () => FirebaseFirestore.instance);
    }

    if (!_locator.isRegistered<FirebaseAuth>()) {
      _locator.registerLazySingleton<FirebaseAuth>(
              () => FirebaseAuth.instance);
    }

    // SharedPreferences
    if (!_locator.isRegistered<SharedPreferences>()) {
      final prefs = await SharedPreferences.getInstance();
      _locator.registerLazySingleton<SharedPreferences>(() => prefs);
    }

    // Data sources
    _locator.registerLazySingleton<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSourceImpl(
        firestore: _locator<FirebaseFirestore>(),
        auth: _locator<FirebaseAuth>(),
      ),
    );

    _locator.registerLazySingleton<ProfileLocalDataSource>(
          () => ProfileLocalDataSourceImpl(
        sharedPreferences: _locator<SharedPreferences>(),
      ),
    );

    // Repository
    _locator.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(
        remoteDataSource: _locator<ProfileRemoteDataSource>(),
        localDataSource: _locator<ProfileLocalDataSource>(),
      ),
    );

    // Bloc - usando factory para ter uma nova instância a cada utilização
    _locator.registerFactory<ProfileBloc>(
          () => ProfileBloc(repository: _locator<ProfileRepository>()),
    );
  }

  /// Retorna a página principal de perfil com o BlocProvider configurado.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   MaterialPageRoute(builder: (_) => ProfileModule.getProfilePage()),
  /// );
  /// ```
  static Widget getProfilePage() {
    return BlocProvider<ProfileBloc>(
      create: (_) => _locator<ProfileBloc>()..add(LoadUserProfileEvent()),
      child: const ProfilePage(),
    );
  }

  /// Retorna a página de edição de perfil com o BlocProvider configurado.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   MaterialPageRoute(builder: (_) => ProfileModule.getEditProfilePage()),
  /// );
  /// ```
  static Widget getEditProfilePage() {
    // Criamos uma nova instância do bloc para a página de edição
    return BlocProvider<ProfileBloc>(
      create: (_) => _locator<ProfileBloc>()..add(LoadUserProfileEvent()),
      child: const EditProfilePage(),
    );
  }

  /// Verifica se todas as dependências necessárias estão registradas.
  /// Útil para debugging durante o desenvolvimento.
  static bool checkDependencies() {
    return _locator.isRegistered<FirebaseFirestore>() &&
        _locator.isRegistered<FirebaseAuth>() &&
        _locator.isRegistered<SharedPreferences>() &&
        _locator.isRegistered<ProfileRemoteDataSource>() &&
        _locator.isRegistered<ProfileLocalDataSource>() &&
        _locator.isRegistered<ProfileRepository>() &&
        _locator.isRegistered<ProfileBloc>();
  }

  /// Limpa todas as dependências registradas por este módulo.
  /// Útil para testes ou para reinicializar o módulo.
  static void dispose() {
    if (_locator.isRegistered<ProfileRemoteDataSource>()) {
      _locator.unregister<ProfileRemoteDataSource>();
    }

    if (_locator.isRegistered<ProfileLocalDataSource>()) {
      _locator.unregister<ProfileLocalDataSource>();
    }

    if (_locator.isRegistered<ProfileRepository>()) {
      _locator.unregister<ProfileRepository>();
    }

    if (_locator.isRegistered<ProfileBloc>()) {
      _locator.unregister<ProfileBloc>();
    }
  }
}
