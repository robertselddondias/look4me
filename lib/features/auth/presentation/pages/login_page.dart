import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/core/widgets/app_button.dart';
import 'package:look4me/features/auth/presentation/widgets/auth_header.dart';
import 'package:look4me/features/auth/presentation/widgets/password_field.dart';
import 'package:look4me/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:look4me/modules/auth/blocs/auth_state.dart';
import 'email_verification_page.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(EmailLoginRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  void _handleGoogleLogin() {
    context.read<AuthBloc>().add(GoogleLoginRequested());
  }

  void _handleAppleLogin() {
    context.read<AuthBloc>().add(AppleLoginRequested());
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
        } else if (state is AuthAuthenticated) {
          if (state.needsEmailVerification) {
            // Redirecionar para a tela de verificação de email
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => EmailVerificationPage(email: state.user.email)),
            );
          } else {
            // Redirecionar para a tela principal
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else if (state is AuthNeedsInvite) {
          // Usuário social novo, precisa de usuário, nome e convite
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CompleteSignupPage(
                email: state.email,
                fullName: state.fullName,
                photoUrl: state.photoUrl,
                authProvider: state.authProvider,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        _isLoading = state is AuthLoading;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: 'Bem-vinda de volta!',
                      subtitle: 'Entre com sua conta para continuar',
                    ),
                    const SizedBox(height: 48),
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
                          const SizedBox(height: 16),
                          PasswordField(
                            controller: _passwordController,
                            hintText: 'Senha',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira sua senha';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: 'Entrar',
                            isGradient: true,
                            isLoading: _isLoading,
                            onPressed: _isLoading ? null : _handleLogin,
                          ),
                          const SizedBox(height: 24),
                          _buildSocialAuthSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => _buildRegisterInfoSheet(context),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Não tem uma conta? ',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Conheça mais',
                                style: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialAuthSection() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ou continue com',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialAuthButton(
              icon: Icons.g_mobiledata,
              color: Colors.red,
              onTap: _isLoading ? null : _handleGoogleLogin,
            ),
            const SizedBox(width: 32),
            SocialAuthButton(
              icon: Icons.apple,
              color: Colors.black,
              onTap: _isLoading ? null : _handleAppleLogin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterInfoSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Sobre o Look4Me',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 16),
          Text(
            'O Look4Me é uma rede social exclusiva para compartilhamento de escolha de looks e dicas de moda.',
            style: TextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  'Acesso exclusivo por convite',
                  style: TextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Para manter nossa comunidade de qualidade, novos cadastros só são possíveis com código de convite de uma usuária já cadastrada.',
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Tenho um código de convite',
            isGradient: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Voltar',
              style: TextStyles.button.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
