import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final bool needsEmailVerification;

  const AuthAuthenticated(this.user, {this.needsEmailVerification = false});

  @override
  List<Object?> get props => [user, needsEmailVerification];
}

class AuthUnauthenticated extends AuthState {}

class AuthNeedsInvite extends AuthState {
  final String? email;
  final String? fullName;
  final String authProvider;
  final String? photoUrl;

  const AuthNeedsInvite({
    this.email,
    this.fullName,
    required this.authProvider,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [email, fullName, authProvider, photoUrl];
}

class AuthEmailSent extends AuthState {
  final String email;

  const AuthEmailSent(this.email);

  @override
  List<Object> get props => [email];
}

class AuthInvitesGenerated extends AuthState {
  final List<String> inviteCodes;

  const AuthInvitesGenerated(this.inviteCodes);

  @override
  List<Object> get props => [inviteCodes];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
