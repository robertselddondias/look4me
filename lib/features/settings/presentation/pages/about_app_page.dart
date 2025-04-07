import 'package:flutter/material.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Look4Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "L4M",
                  style: TextStyles.heading2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Look4Me',
              style: TextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Versão 1.0.0',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Encontre seu look perfeito com a ajuda da comunidade. Look4Me é o aplicativo definitivo para quem busca inspiração e opinião em moda.',
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              '© 2024 Look4Me. Todos os direitos reservados.',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
