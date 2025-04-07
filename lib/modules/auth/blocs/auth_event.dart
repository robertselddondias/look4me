import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailAndPassword({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fullName;

  const SignUpWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, username, fullName];
}

class LogoutRequested extends AuthEvent {}
