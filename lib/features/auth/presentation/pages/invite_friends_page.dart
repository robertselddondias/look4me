import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/core/widgets/app_button.dart';
import 'package:look4me/modules/auth/blocs/auth_bloc.dart';
import 'package:look4me/modules/auth/blocs/auth_event.dart';
import 'package:look4me/modules/auth/blocs/auth_state.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsPage extends StatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  State<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  int _availableInvites = 0;
  List<String> _inviteCodes = [];
  bool _isLoading = false;
  bool _hasGeneratedInvites = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableInvites();
  }

  Future<void> _loadAvailableInvites() async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      final user = (authBloc.state as AuthAuthenticated).user;
      setState(() {
        _availableInvites = user.availableInvites;
      });
    }
  }

  void _generateInvites() {
    if (_availableInvites > 0) {
      context.read<AuthBloc>().add(GenerateInviteRequested());
    }
  }

  void _shareInvite(String inviteCode) {
    Share.share(
      'Junte-se a mim no Look4Me! Use meu código de convite para se cadastrar: $inviteCode\n\nBaixe o app: https://look4me.app/download',
      subject: 'Convite para o Look4Me',
    );
  }

  void _copyInvite(String inviteCode) {
    Clipboard.setData(ClipboardData(text: inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código de convite copiado para a área de transferência'),
        backgroundColor: Colors.green,
      ),
    );
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
          setState(() {
            _isLoading = false;
          });
        } else if (state is AuthInvitesGenerated) {
          setState(() {
            _inviteCodes = state.inviteCodes;
            _availableInvites = 0;
            _hasGeneratedInvites = true;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Códigos de convite gerados com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthAuthenticated) {
          setState(() {
            _availableInvites = state.user.availableInvites;
            _isLoading = false;
          });
        } else if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Convide Amigas'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Convide pessoas para o Look4Me',
                  style: TextStyles.heading2,
                ),
                const SizedBox(height: 16),
                Text(
                  'Convide suas amigas para o Look4Me e ajude nossa comunidade a crescer.',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _buildInvitesSection(),
                const SizedBox(height: 24),
                if (_hasGeneratedInvites && _inviteCodes.isNotEmpty)
                  ..._buildInviteCodesList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvitesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Convites disponíveis',
                style: TextStyles.heading3.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_availableInvites',
                  style: TextStyles.heading1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: _availableInvites > 0
                ? 'Gerar Convites'
                : 'Sem convites disponíveis',
            isGradient: _availableInvites > 0,
            isLoading: _isLoading,
            onPressed: _availableInvites > 0 && !_isLoading
                ? () => _generateInvites()
                : null,
          ),
          if (_availableInvites == 0 && !_hasGeneratedInvites) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Mais convites estarão disponíveis em breve!',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildInviteCodesList() {
    return [
      Text(
        'Seus códigos de convite',
        style: TextStyles.heading3,
      ),
      const SizedBox(height: 16),
      Text(
        'Compartilhe estes códigos com suas amigas. Cada código pode ser usado apenas uma vez.',
        style: TextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 16),
      ..._inviteCodes.map((code) => _buildInviteCodeCard(code)).toList(),
    ];
  }

  Widget _buildInviteCodeCard(String code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    code,
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyInvite(code),
                  tooltip: 'Copiar código',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: () => _shareInvite(code),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.share,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Compartilhar',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
