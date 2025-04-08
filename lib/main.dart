import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/core/di/app_dependencies.dart';
import 'package:look4me/core/theme/app_theme.dart';
import 'package:look4me/features/auth/presentation/pages/splash_page.dart';
import 'package:look4me/features/profile/profile_module.dart';
import 'package:look4me/features/settings/settings_module.dart' as settings;
import 'package:look4me/firebase_options.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Garantir que os widgets estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientação do app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar injeção de dependências
  settings.setupDependencies();

  await ProfileModule.init();

  // Iniciar o app
  runApp(const Look4MeApp());
}

class Look4MeApp extends StatelessWidget {
  const Look4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => locator<AuthBloc>()..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Look4Me',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
