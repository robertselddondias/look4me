// lib/features/stories/presentation/pages/story_creation_page.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class StoryCreationPage extends StatefulWidget {
  const StoryCreationPage({super.key});

  @override
  State<StoryCreationPage> createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();

  int _selectedDuration = 20; // 20 min default
  final List<int> _durations = [10, 20, 30];

  String? _selectedTag;
  final List<String> _predefinedTags = [
    'CompraShopping',
    'EncontroAmigos',
    'JantarRomantico',
    'CasualDoDia',
    'Trabalho',
    'FestaDeFamilia',
    'FimDeSemana',
  ];

  bool _isLoading = false;
  bool _isComplete = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedTag != null) {
      setState(() {
        _isLoading = true;
      });

      // Simulando envio
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isComplete = true;
        });
      });
    } else if (_selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma tag para o evento'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Story Emergencial'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isComplete
          ? _buildSuccessUI()
          : _buildFormUI(),
    );
  }

  Widget _buildFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qual é a sua dúvida?',
              style: TextStyles.heading3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _questionController,
              maxLength: 80,
              decoration: const InputDecoration(
                hintText: 'Ex: Qual vestido devo usar para um encontro?',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, descreva sua dúvida';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Por quanto tempo seu story ficará ativo?',
              style: TextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _durations.map((duration) {
                final isSelected = _selectedDuration == duration;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDuration = duration;
                    });
                  },
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$duration',
                          style: TextStyles.heading2.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'minutos',
                          style: TextStyles.bodySmall.copyWith(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Qual é a ocasião?',
              style: TextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _predefinedTags.map((tag) {
                final isSelected = _selectedTag == tag;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTag = tag;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                          : null,
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyles.bodyMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Faça upload das suas fotos',
              style: TextStyles.heading3,
            ),
            const SizedBox(height: 12),
            _buildImageUploadArea(),
            const SizedBox(height: 40),
            AppButton(
              text: 'Publicar Story',
              isGradient: true,
              isLoading: _isLoading,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadArea() {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: _buildImageUploadCard(0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: _buildImageUploadCard(1),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryLight,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryLight.withOpacity(0.3),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              index == 0 ? 'Opção A' : 'Opção B',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Toque para adicionar foto',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Story publicado com sucesso!',
              style: TextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Seu story emergencial já está ativo. Em breve você começará a receber ajuda da comunidade!',
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$_selectedDuration',
                        style: TextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'minutos',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '0',
                        style: TextStyles.heading2,
                      ),
                      Text(
                        'votos',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Ver meus stories',
              isGradient: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isComplete = false;
                  _questionController.clear();
                  _selectedTag = null;
                });
              },
              child: Text(
                'Criar outro story',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
