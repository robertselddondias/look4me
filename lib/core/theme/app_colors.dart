import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const Color primary = Color(0xFFFF5A8C);
  static const Color primaryLight = Color(0xFFFFB2C7);
  static const Color primaryDark = Color(0xFFD63D6B);

  // Cores secundárias
  static const Color secondary = Color(0xFF8C6FF0);
  static const Color secondaryLight = Color(0xFFBFB2F7);
  static const Color secondaryDark = Color(0xFF6847D3);

  // Cores neutras
  static const Color background = Color(0xFFFAF8FC);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE53935);

  // Texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF8FB3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient storyGradient = LinearGradient(
    colors: [secondary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
