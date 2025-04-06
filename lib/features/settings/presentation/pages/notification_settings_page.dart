import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Notification toggles
  bool _generalNotifications = true;
  bool _likesNotifications = true;
  bool _commentsNotifications = true;
  bool _followersNotifications = true;
  bool _storiesNotifications = true;
  bool _votesNotifications = true;

  // Notification sounds and vibration
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Notification time preferences
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _quietHoursEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Configurações Gerais'),
          SwitchListTile(
            title: Text(
              'Notificações Gerais',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Ativar/desativar todas as notificações',
              style: TextStyles.bodySmall,
            ),
            value: _generalNotifications,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _generalNotifications = value;
                // Desativar todas as notificações específicas se geral estiver desativado
                if (!value) {
                  _likesNotifications = false;
                  _commentsNotifications = false;
                  _followersNotifications = false;
                  _storiesNotifications = false;
                  _votesNotifications = false;
                }
              });
            },
          ),
          _buildSectionHeader('Tipos de Notificação'),
          SwitchListTile(
            title: Text(
              'Likes',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Notificar quando alguém der like',
              style: TextStyles.bodySmall,
            ),
            value: _likesNotifications,
            activeColor: AppColors.primary,
            onChanged: _generalNotifications
                ? (bool value) {
              setState(() {
                _likesNotifications = value;
              });
            }
                : null,
          ),
          SwitchListTile(
            title: Text(
              'Comentários',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Notificar novos comentários',
              style: TextStyles.bodySmall,
            ),
            value: _commentsNotifications,
            activeColor: AppColors.primary,
            onChanged: _generalNotifications
                ? (bool value) {
              setState(() {
                _commentsNotifications = value;
              });
            }
                : null,
          ),
          SwitchListTile(
            title: Text(
              'Seguidores',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Notificar novos seguidores',
              style: TextStyles.bodySmall,
            ),
            value: _followersNotifications,
            activeColor: AppColors.primary,
            onChanged: _generalNotifications
                ? (bool value) {
              setState(() {
                _followersNotifications = value;
              });
            }
                : null,
          ),
          SwitchListTile(
            title: Text(
              'Stories',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Notificar novos stories',
              style: TextStyles.bodySmall,
            ),
            value: _storiesNotifications,
            activeColor: AppColors.primary,
            onChanged: _generalNotifications
                ? (bool value) {
              setState(() {
                _storiesNotifications = value;
              });
            }
                : null,
          ),
          SwitchListTile(
            title: Text(
              'Votos em Looks',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Notificar resultados de votações',
              style: TextStyles.bodySmall,
            ),
            value: _votesNotifications,
            activeColor: AppColors.primary,
            onChanged: _generalNotifications
                ? (bool value) {
              setState(() {
                _votesNotifications = value;
              });
            }
                : null,
          ),
          _buildSectionHeader('Preferências de Notificação'),
          SwitchListTile(
            title: Text(
              'Som de Notificação',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Ativar som para notificações',
              style: TextStyles.bodySmall,
            ),
            value: _soundEnabled,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(
              'Vibração',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Ativar vibração para notificações',
              style: TextStyles.bodySmall,
            ),
            value: _vibrationEnabled,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
          _buildSectionHeader('Modo Silencioso'),
          SwitchListTile(
            title: Text(
              'Horário de Silêncio',
              style: TextStyles.bodyLarge,
            ),
            subtitle: Text(
              'Pausar notificações em um período específico',
              style: TextStyles.bodySmall,
            ),
            value: _quietHoursEnabled,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                _quietHoursEnabled = value;
              });
            },
          ),
          if (_quietHoursEnabled)
            ListTile(
              title: Text(
                'Período de Silêncio',
                style: TextStyles.bodyLarge,
              ),
              subtitle: Text(
                '$_quietHoursStart - $_quietHoursEnd',
                style: TextStyles.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showQuietHoursDialog();
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

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Horário de Silêncio',
          style: TextStyles.heading3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimePicker(
              'Início',
              _quietHoursStart,
                  (newTime) {
                setState(() {
                  _quietHoursStart = newTime;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTimePicker(
              'Fim',
              _quietHoursEnd,
                  (newTime) {
                setState(() {
                  _quietHoursEnd = newTime;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Confirmar',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
      String label,
      String initialTime,
      Function(String) onTimeChanged
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge,
        ),
        TextButton(
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.parse(initialTime.split(':')[0]),
                minute: int.parse(initialTime.split(':')[1]),
              ),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              final newTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              onTimeChanged(newTime);
            }
          },
          child: Text(
            initialTime,
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
