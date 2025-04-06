import 'package:flutter/material.dart';
import 'package:look4me_app/core/theme/app_colors.dart';
import 'package:look4me_app/core/theme/text_styles.dart';
import 'package:look4me_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:look4me_app/features/settings/presentation/pages/about_app_page.dart';
import 'package:look4me_app/features/settings/presentation/pages/appearance_settings_page.dart';
import 'package:look4me_app/features/settings/presentation/pages/help_support_page.dart';
import 'package:look4me_app/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:look4me_app/features/settings/presentation/pages/privacy_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          _buildSettingsSection(
            context,
            'Conta',
            [
              _buildSettingsTile(
                context: context,
                icon: Icons.person_outline,
                title: 'Perfil',
                subtitle: 'Editar informações pessoais',
                page: const EditProfilePage(),
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.lock_outline,
                title: 'Privacidade',
                subtitle: 'Controle sua privacidade',
                page: const PrivacySettingsPage(),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            'Preferências',
            [
              _buildSettingsTile(
                context: context,
                icon: Icons.notifications_outlined,
                title: 'Notificações',
                subtitle: 'Configurar alertas e notificações',
                page: const NotificationSettingsPage(),
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.palette_outlined,
                title: 'Aparência',
                subtitle: 'Personalizar tema do aplicativo',
                page: const AppearanceSettingsPage(),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            'Suporte',
            [
              _buildSettingsTile(
                context: context,
                icon: Icons.help_outline,
                title: 'Ajuda e Suporte',
                subtitle: 'Central de ajuda e informações',
                page: const HelpSupportPage(),
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.info_outline,
                title: 'Sobre o Look4Me',
                subtitle: 'Versão do aplicativo e informações',
                page: const AboutAppPage(),
              ),
            ],
          ),
          _buildLogoutSection(context),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyles.heading3.copyWith(fontSize: 18),
          ),
        ),
        ...tiles,
      ],
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyles.bodySmall,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
          title: Text(
            'Sair da conta',
            style: TextStyles.bodyLarge.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sair da conta',
          style: TextStyles.heading3,
        ),
        content: Text(
          'Tem certeza que deseja sair do Look4Me?',
          style: TextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de logout
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
