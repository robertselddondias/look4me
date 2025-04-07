import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final bool isLoading;
  final bool isGradient;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
    this.isLoading = false,
    this.isGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se isLoading for true, desabilitar o botão
    final VoidCallback? callback = isLoading ? null : onPressed;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: callback,
        style: OutlinedButton.styleFrom(
          minimumSize: isFullWidth ? const Size(double.infinity, 54) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: _buildButtonContent(),
      );
    }

    if (isGradient) {
      return InkWell(
        onTap: callback,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: isFullWidth ? double.infinity : null,
          height: 54,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _buildButtonContent(),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: isFullWidth ? const Size(double.infinity, 54) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        elevation: 2,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: isOutlined ? AppColors.primary : Colors.white,
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyles.button,
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyles.button,
    );
  }
}
