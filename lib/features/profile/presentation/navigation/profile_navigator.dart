import 'package:flutter/material.dart';
import '../../profile_module.dart';

/// Classe utilitária para navegação dentro do módulo de perfil.
/// Centraliza a lógica de navegação e facilita a manutenção.
class ProfileNavigator {
  /// Navega para a página de edição de perfil
  static Future<Future<Object?>> navigateToEditProfile(BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileModule.getEditProfilePage(),
      ),
    );
  }

  /// Navega para a página principal de perfil
  static Future<Future<Object?>> navigateToProfile(BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileModule.getProfilePage(),
      ),
    );
  }

  /// Navega para a página de perfil e remove todas as rotas anteriores
  static void navigateToProfileAndRemoveUntil(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ProfileModule.getProfilePage()),
          (route) => false,
    );
  }
}
