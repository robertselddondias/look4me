import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';
import '../models/invite_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) :
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Verifica se o usuário está autenticado
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Obtém o usuário atual
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return null;
    } catch (e) {
      print('Erro ao obter usuário: $e');
      return null;
    }
  }

  // Autenticação com email e senha
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
      }
      return null;
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  // Cadastro com email e senha (incluindo validação de convite)
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String inviteCode,
  }) async {
    try {
      // Verificar se o convite é válido
      final inviteValid = await _validateInvite(inviteCode);
      if (!inviteValid) {
        throw Exception('Código de convite inválido ou já utilizado');
      }

      // Verificar se o username já existe
      final usernameExists = await _checkUsernameExists(username);
      if (usernameExists) {
        throw Exception('Este nome de usuário já está em uso');
      }

      // Criar usuário
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      final user = userCredential.user;
      if (user != null) {
        // Enviar email de verificação
        await user.sendEmailVerification();

        // Criar documento do usuário
        final newUser = UserModel(
          id: user.uid,
          email: email,
          username: username,
          fullName: fullName,
          createdAt: DateTime.now(),
          isEmailVerified: false,
          invitedBy: inviteCode,
          availableInvites: 3, // Dar 3 convites para o novo usuário
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());

        // Marcar convite como utilizado
        await _markInviteAsUsed(inviteCode, user.uid);

        return newUser;
      }
      return null;
    } catch (e) {
      print('Erro no cadastro: $e');
      rethrow;
    }
  }

  // Login com Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Verificar se o usuário já existe no Firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // Usuário existente - retornar dados
          return UserModel.fromFirestore(userDoc);
        } else {
          // Usuário novo com Google - precisa de convite para continuar
          // O fluxo de cadastro completo com convite será solicitado na UI
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Erro no login com Google: $e');
      rethrow;
    }
  }

  // Login com Apple
  Future<UserModel?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null) {
        // Verificar se o usuário já existe no Firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // Usuário existente - retornar dados
          return UserModel.fromFirestore(userDoc);
        } else {
          // Usuário novo com Apple - precisa de convite para continuar
          // O nome pode estar vazio no Apple Sign In, então precisamos solicitar na UI
          String? fullName;
          if (appleCredential.givenName != null && appleCredential.familyName != null) {
            fullName = '${appleCredential.givenName} ${appleCredential.familyName}';
          }

          // O fluxo de cadastro completo com convite será solicitado na UI
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Erro no login com Apple: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
      rethrow;
    }
  }

  // Verificar se um username já existe
  Future<bool> _checkUsernameExists(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Validar código de convite
  Future<bool> _validateInvite(String inviteCode) async {
    try {
      final inviteDoc = await _firestore.collection('invites').doc(inviteCode).get();

      if (!inviteDoc.exists) return false;

      final inviteData = inviteDoc.data();
      if (inviteData == null) return false;

      final invite = InviteModel.fromFirestore(inviteDoc);

      // Verificar se o convite já foi usado
      if (invite.isUsed) return false;

      // Verificar se o convite expirou
      if (invite.expiresAt.isBefore(DateTime.now())) return false;

      return true;
    } catch (e) {
      print('Erro ao validar convite: $e');
      return false;
    }
  }

  // Marcar convite como usado
  Future<void> _markInviteAsUsed(String inviteCode, String usedByUserId) async {
    try {
      await _firestore.collection('invites').doc(inviteCode).update({
        'isUsed': true,
        'usedByUserId': usedByUserId,
        'usedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao marcar convite como usado: $e');
    }
  }

  // Gerar novos convites para um usuário
  Future<List<String>> generateInvitesForUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception('Usuário não encontrado');

      final user = UserModel.fromFirestore(userDoc);

      if (user.availableInvites <= 0) {
        throw Exception('Você não possui convites disponíveis');
      }

      // Criar batch para operações em lote
      final batch = _firestore.batch();
      final inviteCodes = <String>[];

      // Gerar novos convites
      for (int i = 0; i < user.availableInvites; i++) {
        final inviteRef = _firestore.collection('invites').doc();
        final inviteCode = inviteRef.id;

        final invite = InviteModel(
          id: inviteCode,
          createdBy: userId,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(Duration(days: 7)),
          isUsed: false,
        );

        batch.set(inviteRef, invite.toFirestore());
        inviteCodes.add(inviteCode);
      }

      // Atualizar contagem de convites do usuário
      batch.update(
          _firestore.collection('users').doc(userId),
          {'availableInvites': 0} // Zerar os convites disponíveis
      );

      await batch.commit();

      return inviteCodes;
    } catch (e) {
      print('Erro ao gerar convites: $e');
      rethrow;
    }
  }

  // Verificar quantos convites um usuário tem disponível
  Future<int> getAvailableInvites(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return 0;

      final user = UserModel.fromFirestore(userDoc);
      return user.availableInvites;
    } catch (e) {
      print('Erro ao obter convites disponíveis: $e');
      return 0;
    }
  }

  // Verificar se o email está verificado
  Future<bool> isEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } catch (e) {
      print('Erro ao verificar email: $e');
      return false;
    }
  }

  // Reenviar email de verificação
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Erro ao enviar email de verificação: $e');
      rethrow;
    }
  }
}
