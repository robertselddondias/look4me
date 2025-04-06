import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _dataSharing = true;
  bool _locationSharing = false;
  String _contactDiscovery = 'Desativado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidade'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Compartilhamento de Dados'),
          SwitchListTile(
            title: Text(
              'Compartilhamento de Dados',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Permitir que usemos seus dados para melhorar a experiência',
              style: TextStyles.bodySmall,
            ),
            value: _dataSharing,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _dataSharing = value;
              });
            },
          ),
          _buildSectionHeader('Localização'),
          SwitchListTile(
            title: Text(
              'Compartilhar Localização',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Ativar recomendações baseadas na sua localização',
              style: TextStyles.bodySmall,
            ),
            value: _locationSharing,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _locationSharing = value;
              });
            },
          ),
          _buildSectionHeader('Descoberta de Contatos'),
          ListTile(
            title: Text(
              'Descoberta de Contatos',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              _contactDiscovery,
              style: TextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showContactDiscoveryBottomSheet();
            },
          ),
          _buildSectionHeader('Segurança'),
          ListTile(
            title: Text(
              'Gerenciar Dispositivos Conectados',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Visualizar e desconectar dispositivos',
              style: TextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showConnectedDevicesDialog();
            },
          ),
          ListTile(
            title: Text(
              'Alterar Senha',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Modificar a senha da sua conta',
              style: TextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navegar para a tela de alteração de senha
            },
          ),
          _buildSectionHeader('Bloqueios'),
          ListTile(
            title: Text(
              'Usuários Bloqueados',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Gerenciar lista de usuários bloqueados',
              style: TextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showBlockedUsersDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyles.heading3.copyWith(fontSize: 18),
      ),
    );
  }

  void _showContactDiscoveryBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Descoberta de Contatos',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 20),
          _buildDiscoveryOption('Desativado', 'Ninguém pode me encontrar por contatos'),
          _buildDiscoveryOption('Meus Contatos', 'Apenas contatos da minha agenda'),
          _buildDiscoveryOption('Todos', 'Qualquer usuário pode me encontrar'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDiscoveryOption(String title, String description) {
    return ListTile(
      title: Text(
        title,
        style: TextStyles.bodyLarge,
      ),
      subtitle: Text(
        description,
        style: TextStyles.bodySmall,
      ),
      trailing: _contactDiscovery == title
          ? Icon(
        Icons.check_circle,
        color: AppColors.primary,
      )
          : null,
      onTap: () {
        setState(() {
          _contactDiscovery = title;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showConnectedDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Dispositivos Conectados',
          style: TextStyles.heading3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDeviceItem('iPhone 12', 'São Paulo, Brasil', '2 dias atrás'),
            _buildDeviceItem('MacBook Pro', 'São Paulo, Brasil', '1 hora atrás'),
            _buildDeviceItem('Samsung Galaxy', 'Campinas, Brasil', '3 dias atrás'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(String name, String location, String lastActive) {
    return ListTile(
      title: Text(
        name,
        style: TextStyles.bodyLarge,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: TextStyles.bodySmall,
          ),
          Text(
            'Última atividade: $lastActive',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      trailing: TextButton(
        onPressed: () {
          // Lógica para desconectar dispositivo
        },
        child: Text(
          'Desconectar',
          style: TextStyles.bodySmall.copyWith(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void _showBlockedUsersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Usuários Bloqueados',
          style: TextStyles.heading3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBlockedUserItem('maria_style', 'Maria Silva'),
            _buildBlockedUserItem('fashion_julia', 'Julia Santos'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUserItem(String username, String name) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
        ),
      ),
      title: Text(
        username,
        style: TextStyles.bodyLarge,
      ),
      subtitle: Text(
        name,
        style: TextStyles.bodySmall,
      ),
      trailing: TextButton(
        onPressed: () {
          // Lógica para desbloquear usuário
        },
        child: Text(
          'Desbloquear',
          style: TextStyles.bodySmall.copyWith(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
