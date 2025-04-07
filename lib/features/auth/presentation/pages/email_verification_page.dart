import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/features/navigation/presentation/pages/main_navigation.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:look4me/modules/auth/blocs/auth_state.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _isCheckingEmail = false;

  @override
  void initState() {
    super.initState();
    // Enviar email de verificação logo que a página é carregada
    context.read<AuthBloc>().add(VerifyEmail());
    _startTimer();

    // Configurar timer para verificar periodicamente se o email foi confirmado
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_isCheckingEmail) {
        setState(() {
          _isCheckingEmail = true;
        });
        context.read<AuthBloc>().add(CheckEmailVerification());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendVerification() {
    if (_canResend) {
      context.read<AuthBloc>().add(ResendEmailVerification());
      setState(() {
        _canResend = false;
        _remainingSeconds = 60;
      });
      _startTimer();
    }
  }

  void _manualCheckVerification() {
    setState(() {
      _isCheckingEmail = true;
    });
    context.read<AuthBloc>().add(CheckEmailVerification());

    // Configurar um timer para resetar o estado depois de um tempo caso não venha resposta
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isCheckingEmail) {
        setState(() {
          _isCheckingEmail = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parece que seu email ainda não foi verificado. Verifique e tente novamente.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() {
            _isCheckingEmail = false;
          });
        } else if (state is AuthEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email de verificação enviado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthAuthenticated && !state.needsEmailVerification) {
          // Correção: Redirecionar para a tela principal usando MainNavigation
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        } else {
          setState(() {
            _isCheckingEmail = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verificação de Email'),
            automaticallyImplyLeading: false, // Remover botão voltar
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mark_email_read,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Verifique seu email',
                  style: TextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enviamos um link de verificação para:\n${widget.email}',
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Verifique sua caixa de entrada e spam para concluir o cadastro.',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isCheckingEmail ? null : () {
                    setState(() {
                      _isCheckingEmail = true;
                    });
                    context.read<AuthBloc>().add(CheckEmailVerification());
                  },
                  child: Text(
                    _isCheckingEmail ? 'Verificando...' : 'Já verifiquei meu email',
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _canResend ? _resendVerification : null,
                  child: Text(
                    _canResend
                        ? 'Reenviar email de verificação'
                        : 'Reenviar em $_remainingSeconds segundos',
                    style: TextStyles.bodyMedium.copyWith(
                      color: _canResend ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    // Logout e volta para login
                    context.read<AuthBloc>().add(LogoutRequested());
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.textSecondary),
                  ),
                  child: Text(
                    'Sair',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
