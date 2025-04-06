// lib/features/auth/presentation/pages/otp_verification_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look4me_app/core/theme/app_colors.dart';
import 'package:look4me_app/core/theme/text_styles.dart';
import 'package:look4me_app/core/widgets/app_button.dart';
import 'package:look4me_app/features/navigation/presentation/pages/main_navigation.dart';
import 'dart:async';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String verificationPurpose; // 'registration' ou 'password_reset'

  const OtpVerificationPage({
    Key? key,
    required this.email,
    required this.verificationPurpose,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
        (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
        (_) => FocusNode(),
  );

  late Timer _timer;
  int _remainingSeconds = 60;
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _isResending = true;
    });

    // Simular reenvio
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isResending = false;
        _remainingSeconds = 60;

        // Limpar todos os campos
        for (var controller in _controllers) {
          controller.clear();
        }

        // Focar no primeiro campo
        if (_focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
      });
      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Novo código enviado com sucesso!'),
          backgroundColor: AppColors.primary,
        ),
      );
    });
  }

  void _verifyCode() {
    // Verificar se todos os campos estão preenchidos
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira o código completo'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() {
      _isVerifying = true;
    });

    // Simular verificação
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVerifying = false;
      });

      // Redirecionar com base no propósito da verificação
      if (widget.verificationPurpose == 'registration') {
        // Se for registro, ir para o app principal
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
              (route) => false,
        );
      } else if (widget.verificationPurpose == 'password_reset') {
        // Se for redefinição de senha, ir para a tela de redefinição
        // Navigator.of(context).push(
        //   // MaterialPageRoute(
        //   //   builder: (_) => ResetPasswordPage(
        //   //     token: _getFullCode(), // Usando o código como token
        //   //   ),
        //   // ),
        // );
      }
    });
  }

  String _getFullCode() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Digite o código de verificação',
              style: TextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enviamos um código de 6 dígitos para ${widget.email}',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildOtpFields(),
            const SizedBox(height: 32),
            AppButton(
              text: _isVerifying ? 'Verificando...' : 'Verificar',
              isGradient: true,
              isLoading: _isVerifying,
              onPressed: () => {},//_isVerifying ? null : () => _verifyCode(),
            ),
            const SizedBox(height: 24),
            Center(
              child: _remainingSeconds > 0
                  ? RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Reenviar código em ',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: '$_remainingSeconds segundos',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
                  : TextButton(
                onPressed: _isResending ? null : _resendCode,
                child: Text(
                  _isResending ? 'Reenviando...' : 'Reenviar código',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) => _buildDigitField(index),
      ),
    );
  }

  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyles.heading3,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.textHint, width: 1),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Se foi digitado um valor, avançar para o próximo campo
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Se for o último campo, esconder o teclado
              FocusScope.of(context).unfocus();
            }
          }
        },
      ),
    );
  }
}
