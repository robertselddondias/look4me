// lib/features/feed/presentation/pages/new_post_page.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final List<Map<String, dynamic>> _predefinedTags = [
    {'tag': 'JantarRomantico', 'icon': Icons.favorite},
    {'tag': 'EntrevistaEmprego', 'icon': Icons.work},
    {'tag': 'FestaCasual', 'icon': Icons.celebration},
    {'tag': 'DiaDeTrabalho', 'icon': Icons.business_center},
    {'tag': 'EncontroAmigos', 'icon': Icons.group},
    {'tag': 'CasamentoFormal', 'icon': Icons.cake},
    {'tag': 'FimDeSemana', 'icon': Icons.weekend},
    {'tag': 'Academia', 'icon': Icons.fitness_center},
  ];

  String? _selectedTag;
  bool _isUploading = false;
  bool _isPostingComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Look'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isPostingComplete
          ? _buildSuccessUI()
          : _buildPostCreationUI(),
    );
  }

  Widget _buildPostCreationUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qual será a ocasião?',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 16),
          _buildTagsGrid(),
          const SizedBox(height: 32),
          Text(
            'Faça upload das suas fotos',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 16),
          _buildImageUploadArea(),
          const SizedBox(height: 32),
          Text(
            'Informações da marca (opcional)',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Nome da marca',
              prefixIcon: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(height: 40),
          AppButton(
            text: 'Publicar',
            isGradient: true,
            isLoading: _isUploading,
            onPressed: () => {}
          ),
        ],
      ),
    );
  }

  Widget _buildTagsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _predefinedTags.length,
      itemBuilder: (context, index) {
        final tag = _predefinedTags[index];
        final isSelected = _selectedTag == tag['tag'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTag = tag['tag'];
            });
          },
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tag['icon'],
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  '#${tag['tag']}',
                  style: TextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
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
    // Simulando imagens já selecionadas para o propósito do protótipo
    final bool hasImage = Random().nextBool();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryLight,
          width: 2,
        ),
        image: hasImage
            ? DecorationImage(
          image: NetworkImage(
            index == 0
                ? 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80'
                : 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
          ),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: hasImage
          ? Stack(
        children: [
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: () {
                  // Remover imagem
                },
              ),
            ),
          ),
          if (index == 0)
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Look A',
                  style: TextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (index == 1)
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Look B',
                  style: TextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primaryLight.withOpacity(0.3),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              index == 0 ? 'Look A' : 'Look B',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toque para adicionar foto',
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
              'Publicado com sucesso!',
              style: TextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Seu look foi compartilhado. As pessoas já podem começar a votar e ajudar você a decidir.',
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            AppButton(
              text: 'Ver no Feed',
              isGradient: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Criar Novo Post',
              isOutlined: true,
              onPressed: () {
                setState(() {
                  _isPostingComplete = false;
                  _selectedTag = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
