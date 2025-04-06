import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look4me_app/core/theme/app_theme.dart';
import 'package:look4me_app/features/auth/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const Look4MeApp());
}

class Look4MeApp extends StatelessWidget {
  const Look4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Look4Me',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
