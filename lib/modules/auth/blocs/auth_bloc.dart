import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event,
      Emitter<AuthState> emit
      ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password
      );
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event,
      Emitter<AuthState> emit
      ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
          email: event.email,
          password: event.password,
          username: event.username,
          fullName: event.fullName
      );
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit
      ) async {
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
