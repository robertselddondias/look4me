import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class CheckAuthState extends AuthEvent {}

class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailLoginRequested({
    required this.email,
    required this.password
  });

  @override
  List<Object> get props => [email, password];
}

class GoogleLoginRequested extends AuthEvent {}

class AppleLoginRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fullName;
  final String inviteCode;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
    required this.inviteCode,
  });

  @override
  List<Object> get props => [email, password, username, fullName, inviteCode];
}

class SocialSignUpCompleted extends AuthEvent {
  final String username;
  final String fullName;
  final String inviteCode;
  final String? email;
  final String authProvider;

  const SocialSignUpCompleted({
    required this.username,
    required this.fullName,
    required this.inviteCode,
    this.email,
    required this.authProvider,
  });

  @override
  List<Object?> get props => [username, fullName, inviteCode, email, authProvider];
}

class VerifyEmail extends AuthEvent {}

class ResendEmailVerification extends AuthEvent {}

class CheckEmailVerification extends AuthEvent {}

class GenerateInviteRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
