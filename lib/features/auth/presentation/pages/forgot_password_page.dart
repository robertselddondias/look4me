import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/core/widgets/app_button.dart';
import 'package:look4me/features/auth/presentation/widgets/auth_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );

        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });

        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Nenhuma conta encontrada com este e-mail.';
            break;
          case 'invalid-email':
            message = 'E-mail inválido.';
            break;
          default:
            message = 'Erro ao enviar e-mail de recuperação: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar e-mail de recuperação: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _emailSent ? _buildSuccessUI() : _buildFormUI(),
        ),
      ),
    );
  }

  Widget _buildFormUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: 'Esqueceu sua senha?',
            subtitle: 'Enviaremos um link para redefinir sua senha',
            showLogo: false,
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Enviar link de recuperação',
                  isGradient: true,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleResetPassword,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mark_email_read,
          size: 80,
          color: AppColors.primary,
        ),
        const SizedBox(height: 32),
        Text(
          'E-mail enviado!',
          style: TextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Enviamos um link de recuperação para:\n${_emailController.text}',
          style: TextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'Verifique sua caixa de entrada e siga as instruções no e-mail para redefinir sua senha.',
          style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        AppButton(
          text: 'Voltar para o login',
          isGradient: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
