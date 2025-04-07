import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class AppTranslations {
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
    Locale('es', 'ES')
  ];

  static const String translationPath = 'assets/translations';
  static final Locale fallbackLocale = Locale('pt', 'BR');

  // Métodos úteis para traduções
  static String translate(String key) {
    return key.tr();
  }

  static String translateWithArgs(String key, {List<String>? args}) {
    return key.tr(args: args);
  }
}
