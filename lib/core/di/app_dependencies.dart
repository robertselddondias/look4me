// lib/core/di/app_dependencies.dart

import 'package:get_it/get_it.dart';
import 'package:look4me/core/services/auth_service.dart';
import 'package:look4me/modules/auth/repositories/auth_repository.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';

// Singleton para gerenciar dependências do app
final GetIt locator = GetIt.instance;

// Configurar injeção de dependências
void setupDependencies() {
  // Serviços
  locator.registerLazySingleton<AuthService>(() => AuthService());

  // Repositórios
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // BLoCs
  locator.registerFactory<AuthBloc>(() => AuthBloc(locator<AuthRepository>()));
}
