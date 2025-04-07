import 'package:flutter/material.dart';
import 'package:look4me/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:look4me/features/settings/presentation/pages/settings_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const Divider(),
            _buildStatsSection(),
            const Divider(),
            _buildTabBar(),
            _buildLookGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'maria_style',
                      style: TextStyles.heading3,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Fashion Expert',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Maria Silva',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apaixonada por moda e combinações de roupas. Sempre em busca do look perfeito para cada ocasião.',
                  style: TextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Editar perfil',
                  isOutlined: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('Posts', '24'),
          _buildStatColumn('Seguidores', '1.2K'),
          _buildStatColumn('Seguindo', '348'),
          _buildStatColumn('Likes', '8.5K'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyles.heading3,
        ),
        Text(
          label,
          style: TextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(
                Icons.grid_on,
                color: AppColors.primary,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 2,
                width: 30,
                color: AppColors.primary,
              ),
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.favorite_border,
                color: AppColors.textSecondary,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 2,
                width: 30,
                color: Colors.transparent,
              ),
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.bookmark_border,
                color: AppColors.textSecondary,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 2,
                width: 30,
                color: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLookGrid() {
    final List<String> lookImages = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      'https://images.unsplash.com/photo-1529903384065-b623f72add75?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: lookImages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(lookImages[index]),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (index % 3 == 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.layers,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
