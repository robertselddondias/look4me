// lib/core/services/auth_service.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

class AuthService {
  static const String USER_DATA_KEY = 'user_data';
  static const String IS_FIRST_TIME_KEY = 'is_first_time';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Verificar se o usuário está logado e retornar o modelo do usuário
  Future<UserModel?> getCurrentUser() async {
    try {
      // Primeiro verificar se há um usuário autenticado no Firebase
      final User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        // Obter dados do usuário do Firestore
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromFirestore(userDoc);

          // Salvar dados do usuário no SharedPreferences para acesso rápido futuro
          _saveUserLocally(userData);

          return userData;
        }
      }

      // Se não estiver autenticado no Firebase, verificar se temos dados locais
      return await _getCachedUser();
    } catch (e) {
      print('Erro ao obter usuário atual: $e');
      return null;
    }
  }

  // Salvar dados do usuário localmente
  Future<void> _saveUserLocally(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = _userModelToJson(user);
      await prefs.setString(USER_DATA_KEY, userJson);
      print('Usuário salvo localmente: ${user.username}');
    } catch (e) {
      print('Erro ao salvar usuário localmente: $e');
    }
  }

  // Obter usuário do cache local
  Future<UserModel?> _getCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(USER_DATA_KEY);

      if (userJson != null && userJson.isNotEmpty) {
        final userData = _userModelFromJson(userJson);
        print('Usuário recuperado do cache local: ${userData.username}');
        return userData;
      }

      return null;
    } catch (e) {
      print('Erro ao recuperar usuário do cache: $e');
      return null;
    }
  }

  // Converter UserModel para JSON
  String _userModelToJson(UserModel user) {
    final Map<String, dynamic> data = {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'fullName': user.fullName,
      'photoUrl': user.photoUrl,
      'bio': user.bio,
      'isEmailVerified': user.isEmailVerified,
      'createdAt': user.createdAt.millisecondsSinceEpoch,
      'availableInvites': user.availableInvites,
      'authProvider': user.authProvider,
    };

    return jsonEncode(data);
  }

  // Converter JSON para UserModel
  UserModel _userModelFromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);

    return UserModel(
      id: data['id'],
      email: data['email'],
      username: data['username'],
      fullName: data['fullName'],
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      availableInvites: data['availableInvites'] ?? 0,
      authProvider: data['authProvider'] ?? 'email',
    );
  }

  // Verificar se é a primeira vez que o app é executado
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_FIRST_TIME_KEY) ?? true;
  }

  // Marcar que o app já foi executado antes
  Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(IS_FIRST_TIME_KEY, false);
    print('App marcado como não sendo primeira execução');
  }

  // Login com email e senha
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromFirestore(userDoc);
          _saveUserLocally(userData);
          return userData;
        }
      }

      return null;
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Limpar dados locais do usuário
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(USER_DATA_KEY);

      print('Logout realizado e dados locais limpos');
    } catch (e) {
      print('Erro ao fazer logout: $e');
      rethrow;
    }
  }

  // Verificar se o email está verificado
  Future<bool> isEmailVerified() async {
    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      print('Erro ao verificar email: $e');
      return false;
    }
  }
}
