import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocaleHelper {
  static void changeLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  static Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }

  static bool isCurrentLocale(BuildContext context, Locale locale) {
    return context.locale == locale;
  }

  static List<String> getLanguageCodes() {
    return ['pt', 'en', 'es'];
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'Português';
    }
  }
}
