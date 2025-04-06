// lib/features/auth/presentation/pages/reset_password_page.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_field.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String token;

  const ForgotPasswordPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isComplete = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulando requisição de redefinição de senha
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isComplete = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir senha'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isComplete ? _buildSuccessUI() : _buildFormUI(),
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
            title: 'Crie uma nova senha',
            subtitle: 'Sua nova senha deve ser diferente das senhas usadas anteriormente.',
            showLogo: false,
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PasswordField(
                  controller: _passwordController,
                  hintText: 'Nova senha',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma nova senha';
                    }
                    if (value.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmar nova senha',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordRequirements(),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Redefinir senha',
                  isGradient: true,
                  isLoading: _isLoading,
                  onPressed: _handleReset,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sua senha deve incluir:',
          style: TextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildRequirementItem('Pelo menos 8 caracteres'),
        _buildRequirementItem('Pelo menos um número'),
        _buildRequirementItem('Pelo menos uma letra maiúscula'),
        _buildRequirementItem('Pelo menos um caractere especial'),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.primary.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 80,
          color: AppColors.primary,
        ),
        const SizedBox(height: 32),
        Text(
          'Senha redefinida com sucesso!',
          style: TextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Sua senha foi alterada com sucesso. Agora você pode entrar na sua conta com a nova senha.',
          style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        AppButton(
          text: 'Entrar na minha conta',
          isGradient: true,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
}
