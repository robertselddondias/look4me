import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/core/widgets/app_button.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:look4me/modules/auth/blocs/auth_state.dart';
import 'package:look4me/features/auth/presentation/widgets/auth_header.dart';
import 'package:look4me/features/auth/presentation/widgets/password_field.dart';
import 'package:look4me/features/auth/presentation/widgets/social_auth_button.dart';
import 'email_verification_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  final String? inviteCode; // Pode ser passado na navegação

  const SignupPage({super.key, this.inviteCode});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Se houver um código de convite passado como parâmetro, preencha o campo
    if (widget.inviteCode != null) {
      _inviteCodeController.text = widget.inviteCode!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate() && _acceptedTerms) {
      context.read<AuthBloc>().add(SignUpRequested(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        fullName: _nameController.text,
        inviteCode: _inviteCodeController.text,
      ));
    } else if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para continuar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleGoogleSignup() {
    context.read<AuthBloc>().add(GoogleLoginRequested());
  }

  void _handleAppleSignup() {
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
                      title: 'Crie sua conta',
                      subtitle: 'Junte-se à comunidade Look4Me com seu convite',
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Nome completo',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu nome';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Nome de usuário',
                              prefixIcon: Icon(Icons.alternate_email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um nome de usuário';
                              }
                              if (value.contains(' ')) {
                                return 'O nome de usuário não pode conter espaços';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                                return 'Por favor, insira uma senha';
                              }
                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _inviteCodeController,
                            decoration: const InputDecoration(
                              hintText: 'Código de convite',
                              prefixIcon: Icon(Icons.card_giftcard),
                              helperText: 'Solicite um código de convite a uma amiga que já usa o app',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um código de convite';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptedTerms,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _acceptedTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Eu aceito os ',
                                    style: TextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Termos de Serviço',
                                        style: TextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' e ',
                                      ),
                                      TextSpan(
                                        text: 'Política de Privacidade',
                                        style: TextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: 'Cadastrar',
                            isGradient: true,
                            isLoading: _isLoading,
                            onPressed: _isLoading ? null : _handleSignup,
                          ),
                          const SizedBox(height: 24),
                          _buildSocialAuthSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Já tem uma conta? ',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Entrar',
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
                'Ou cadastre-se com',
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
              onTap: _isLoading ? null : _handleGoogleSignup,
            ),
            const SizedBox(width: 32),
            SocialAuthButton(
              icon: Icons.apple,
              color: Colors.black,
              onTap: _isLoading ? null : _handleAppleSignup,
            ),
          ],
        ),
      ],
    );
  }
}

// Página para completar cadastro após login social
class CompleteSignupPage extends StatefulWidget {
  final String? email;
  final String? fullName;
  final String? photoUrl;
  final String authProvider;

  const CompleteSignupPage({
    super.key,
    this.email,
    this.fullName,
    this.photoUrl,
    required this.authProvider,
  });

  @override
  State<CompleteSignupPage> createState() => _CompleteSignupPageState();
}

class _CompleteSignupPageState extends State<CompleteSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Preencher nome se disponível
    if (widget.fullName != null) {
      _nameController.text = widget.fullName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _handleComplete() {
    if (_formKey.currentState!.validate() && _acceptedTerms) {
      context.read<AuthBloc>().add(SocialSignUpCompleted(
        username: _usernameController.text,
        fullName: _nameController.text,
        inviteCode: _inviteCodeController.text,
        email: widget.email,
        authProvider: widget.authProvider,
      ));
    } else if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para continuar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
          // Redirecionar para a tela principal
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      builder: (context, state) {
        _isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Complete seu cadastro'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Fazer logout ao voltar e retornar para login
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.photoUrl != null)
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.photoUrl!),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Complete seu perfil',
                    style: TextStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Precisamos de algumas informações para finalizar seu cadastro',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              labelText: 'Nome de usuário',
                              prefixIcon: Icon(Icons.alternate_email),
                              helperText: 'Escolha um nome de usuário único'
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome de usuário';
                            }
                            if (value.contains(' ')) {
                              return 'O nome de usuário não pode conter espaços';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (widget.email != null)
                          TextFormField(
                            initialValue: widget.email,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.email_outlined),
                              helperText: 'Email vinculado à sua conta',
                            ),
                          ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _inviteCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Código de convite',
                            prefixIcon: Icon(Icons.card_giftcard),
                            helperText: 'Solicite um código de convite a uma amiga que já usa o app',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um código de convite';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptedTerms,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Eu aceito os ',
                                  style: TextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Termos de Serviço',
                                      style: TextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' e ',
                                    ),
                                    TextSpan(
                                      text: 'Política de Privacidade',
                                      style: TextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        AppButton(
                          text: 'Concluir cadastro',
                          isGradient: true,
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleComplete,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
