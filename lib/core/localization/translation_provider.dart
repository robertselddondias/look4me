import 'package:flutter/material.dart';

class TranslationProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('pt', 'BR');

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}
