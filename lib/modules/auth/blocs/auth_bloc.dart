import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:look4me/modules/auth/models/user_model.dart';
import 'package:look4me/modules/auth/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<CheckAuthState>(_onCheckAuthState);
    on<EmailLoginRequested>(_onEmailLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<AppleLoginRequested>(_onAppleLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SocialSignUpCompleted>(_onSocialSignUpCompleted);
    on<VerifyEmail>(_onVerifyEmail);
    on<ResendEmailVerification>(_onResendEmailVerification);
    on<CheckEmailVerification>(_onCheckEmailVerification);
    on<GenerateInviteRequested>(_onGenerateInviteRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        // Verificar se o email está verificado
        final isEmailVerified = await _authRepository.isEmailVerified();
        emit(AuthAuthenticated(user, needsEmailVerification: !isEmailVerified));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckAuthState(CheckAuthState event, Emitter<AuthState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        // Verificar se o email está verificado
        final isEmailVerified = await _authRepository.isEmailVerified();
        emit(AuthAuthenticated(user, needsEmailVerification: !isEmailVerified));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onEmailLoginRequested(EmailLoginRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password
      );

      if (user != null) {
        // Verificar se o email está verificado
        final isEmailVerified = await _authRepository.isEmailVerified();
        emit(AuthAuthenticated(user, needsEmailVerification: !isEmailVerified));
      } else {
        emit(const AuthError("Usuário não encontrado"));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Nenhum usuário encontrado com este e-mail.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'user-disabled':
          message = 'Esta conta foi desativada.';
          break;
        case 'too-many-requests':
          message = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        default:
          message = 'Erro ao fazer login: ${e.message}';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onGoogleLoginRequested(GoogleLoginRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        // Usuário já existe, verificar email
        final isEmailVerified = await _authRepository.isEmailVerified();
        emit(AuthAuthenticated(user, needsEmailVerification: !isEmailVerified));
      } else {
        // Usuário novo, precisa completar cadastro com convite
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          emit(AuthNeedsInvite(
            email: currentUser.email,
            fullName: currentUser.displayName,
            photoUrl: currentUser.photoURL,
            authProvider: 'google',
          ));
        } else {
          emit(const AuthError("Erro ao fazer login com Google"));
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAppleLoginRequested(AppleLoginRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithApple();

      if (user != null) {
        // Usuário já existe, verificar email
        final isEmailVerified = await _authRepository.isEmailVerified();
        emit(AuthAuthenticated(user, needsEmailVerification: !isEmailVerified));
      } else {
        // Usuário novo, precisa completar cadastro com convite
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          emit(AuthNeedsInvite(
            email: currentUser.email,
            fullName: currentUser.displayName,
            photoUrl: currentUser.photoURL,
            authProvider: 'apple',
          ));
        } else {
          emit(const AuthError("Erro ao fazer login com Apple"));
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignUpRequested(SignUpRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        fullName: event.fullName,
        inviteCode: event.inviteCode,
      );

      if (user != null) {
        emit(AuthAuthenticated(user, needsEmailVerification: true));
      } else {
        emit(const AuthError("Falha ao criar conta"));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este e-mail já está sendo usado.';
          break;
        case 'weak-password':
          message = 'A senha é muito fraca.';
          break;
        case 'invalid-email':
          message = 'E-mail inválido.';
          break;
        default:
          message = 'Erro ao criar conta: ${e.message}';
      }
      emit(AuthError(message));
    } catch (e) {
      if (e.toString().contains('Código de convite inválido')) {
        emit(const AuthError('Código de convite inválido ou expirado.'));
      } else if (e.toString().contains('nome de usuário já está em uso')) {
        emit(const AuthError('Este nome de usuário já está em uso.'));
      } else {
        emit(AuthError('Erro ao criar conta: ${e.toString()}'));
      }
    }
  }

  void _onSocialSignUpCompleted(SocialSignUpCompleted event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // O usuário já está autenticado pelo login social,
      // agora precisamos apenas criar o documento no Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(const AuthError(
            "Erro ao concluir cadastro: usuário não autenticado"));
        return;
      }

      // Verificar validade do convite
      final inviteDoc = await FirebaseFirestore.instance
          .collection('invites')
          .doc(event.inviteCode)
          .get();

      if (!inviteDoc.exists || inviteDoc.data()?['isUsed'] == true) {
        emit(const AuthError("Código de convite inválido ou já utilizado"));
        return;
      }

      // Verificar se o username já existe
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: event.username)
          .limit(1)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        emit(const AuthError("Este nome de usuário já está em uso"));
        return;
      }

      // Criar documento do usuário
      final userData = {
        'email': event.email ?? currentUser.email,
        'username': event.username,
        'fullName': event.fullName,
        'photoUrl': currentUser.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'isEmailVerified': currentUser.emailVerified,
        'invitedBy': event.inviteCode,
        'availableInvites': 3, // Novo usuário recebe 3 convites
        'authProvider': event.authProvider,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set(userData);

      // Marcar convite como usado
      await FirebaseFirestore.instance
          .collection('invites')
          .doc(event.inviteCode)
          .update({
        'isUsed': true,
        'usedByUserId': currentUser.uid,
        'usedAt': FieldValue.serverTimestamp(),
      });

      // Buscar usuário atualizado
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final user = UserModel.fromFirestore(userDoc);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onVerifyEmail(VerifyEmail event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.sendEmailVerification();
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthEmailSent(user.email));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onResendEmailVerification(ResendEmailVerification event,
      Emitter<AuthState> emit) async {
    try {
      await _authRepository.sendEmailVerification();
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthEmailSent(user.email));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckEmailVerification(CheckEmailVerification event,
      Emitter<AuthState> emit) async {
    try {
      final isVerified = await _authRepository.isEmailVerified();
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        if (isVerified) {
          // Atualizar o status de verificação de email no Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .update({'isEmailVerified': true});

          final updatedUser = user.copyWith(isEmailVerified: true);
          emit(AuthAuthenticated(updatedUser));
        } else {
          emit(AuthAuthenticated(user, needsEmailVerification: true));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onGenerateInviteRequested(GenerateInviteRequested event,
      Emitter<AuthState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }

      if (user.availableInvites <= 0) {
        emit(const AuthError("Você não possui convites disponíveis"));
        return;
      }

      final inviteCodes = await _authRepository.generateInvitesForUser(user.id);
      emit(AuthInvitesGenerated(inviteCodes));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogoutRequested(LogoutRequested event,
      Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
