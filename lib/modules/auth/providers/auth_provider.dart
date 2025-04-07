// lib/modules/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:look4me/modules/auth/repositories/auth_repository.dart';

class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepository>(),
        )..add(AppStarted()),
        child: child,
      ),
    );
  }
}
