import 'package:flutter/material.dart';
import 'package:look4me_app/core/theme/app_colors.dart';
import 'package:look4me_app/core/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey<FormState> _feedbackFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir o link: $url'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir o link: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _submitFeedback() {
    if (_feedbackFormKey.currentState!.validate()) {
      // Lógica para enviar feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Obrigado pelo seu feedback!'),
          backgroundColor: AppColors.primary,
        ),
      );
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda e Suporte'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Central de Ajuda'),
          _buildHelpOption(
            icon: Icons.help_outline,
            title: 'Perguntas Frequentes',
            onTap: () {
              _showFAQBottomSheet();
            },
          ),
          _buildHelpOption(
            icon: Icons.contact_support_outlined,
            title: 'Contatar Suporte',
            onTap: () {
              _showContactSupportBottomSheet();
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Recursos Online'),
          _buildLinkOption(
            icon: Icons.description_outlined,
            title: 'Termos de Serviço',
            onTap: () {
              _launchURL('https://look4me.com/termos');
            },
          ),
          _buildLinkOption(
            icon: Icons.privacy_tip_outlined,
            title: 'Política de Privacidade',
            onTap: () {
              _launchURL('https://look4me.com/privacidade');
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Enviar Feedback'),
          _buildFeedbackForm(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyles.heading3.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
        style: TextStyles.bodyLarge,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLinkOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
        style: TextStyles.bodyLarge,
      ),
      trailing: const Icon(
        Icons.open_in_new,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _feedbackFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Nos conte como podemos melhorar o Look4Me',
              hintStyle: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, escreva seu feedback';
              }
              if (value.length < 10) {
                return 'Feedback muito curto. Por favor, seja mais específico.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitFeedback,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Enviar Feedback',
              style: TextStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  void _showFAQBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Perguntas Frequentes',
                style: TextStyles.heading3,
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildFAQItem(
                      'Como funciona o Look4Me?',
                      'O Look4Me é uma plataforma onde você pode postar dois looks e receber ajuda da comunidade para escolher o melhor. Você pode criar posts de comparação e stories emergenciais para obter feedback rápido.',
                    ),
                    _buildFAQItem(
                      'Posso excluir meus posts?',
                      'Sim, você pode excluir qualquer post que tenha criado a qualquer momento. Basta ir até o post e selecionar a opção de exclusão.',
                    ),
                    _buildFAQItem(
                      'Como ganho distintivos no aplicativo?',
                      'Distintivos são conquistados por engajamento e ajuda à comunidade. Quanto mais você votar, comentar e ajudar outros usuários, maior a chance de ganhar distintivos como Fashion Expert ou Trendsetter.',
                    ),
                    _buildFAQItem(
                      'Meus dados são seguros?',
                      'Sim, levamos a privacidade muito a sério. Todos os seus dados pessoais são protegidos e você pode gerenciar suas configurações de privacidade a qualquer momento.',
                    ),
                    _buildFAQItem(
                      'Posso usar o Look4Me gratuitamente?',
                      'Atualmente, o Look4Me é totalmente gratuito. Você pode criar posts, votar e interagir com a comunidade sem nenhum custo.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      childrenPadding: const EdgeInsets.all(16),
      children: [
        Text(
          answer,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showContactSupportBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contatar Suporte',
                style: TextStyles.heading3,
              ),
              const SizedBox(height: 16),
              Text(
                'Entre em contato conosco por e-mail ou redes sociais',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildContactButton(
                    icon: Icons.email_outlined,
                    label: 'E-mail',
                    onTap: () {
                      _launchURL('mailto:suporte@look4me.com');
                    },
                  ),
                  _buildContactButton(
                    icon: Icons.alternate_email,
                    label: 'Instagram',
                    onTap: () {
                      _launchURL('https://instagram.com/look4me_app');
                    },
                  ),
                  _buildContactButton(
                    icon: Icons.chat_outlined,
                    label: 'WhatsApp',
                    onTap: () {
                      _launchURL('https://wa.me/+5511999999999');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: AppColors.primary,
            ),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyles.bodySmall,
        ),
      ],
    );
  }
}
