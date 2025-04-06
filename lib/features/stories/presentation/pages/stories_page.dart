// lib/features/stories/presentation/pages/stories_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import 'story_creation_page.dart';
import 'story_view_page.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dados mockados para os stories emergenciais
  final List<Map<String, dynamic>> _activeStories = [
    {
      'username': 'maria_style',
      'userAvatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'CompraShopping',
      'remainingMinutes': 15,
      'totalVotes': 37,
      'votesA': 62,
      'votesB': 38,
      'question': 'Qual vestido devo comprar para um casamento?',
      'hasVoted': false,
    },
    {
      'username': 'fashion_julia',
      'userAvatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1529903384065-b623f72add75?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'JantarImportante',
      'remainingMinutes': 8,
      'totalVotes': 124,
      'votesA': 27,
      'votesB': 73,
      'question': 'Qual destes sapatos combina melhor para um jantar formal?',
      'hasVoted': true,
    },
    {
      'username': 'laura_moda',
      'userAvatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1549062572-544a64fb0c56?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1591369822096-ffd140ec948f?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'FestaDeFamilia',
      'remainingMinutes': 20,
      'totalVotes': 82,
      'votesA': 45,
      'votesB': 55,
      'question': 'Qual combinação está melhor para um almoço de família?',
      'hasVoted': false,
    },
  ];

  // Dados mockados para os meus stories
  final List<Map<String, dynamic>> _myStories = [
    {
      'question': 'Qual bolsa combina mais com esse vestido?',
      'imageUrls': [
        'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'FestaCasual',
      'totalVotes': 56,
      'votesA': 72,
      'votesB': 28,
      'expiresIn': '12 minutos',
      'status': 'active',
    },
    {
      'question': 'Qual blusa devo comprar?',
      'imageUrls': [
        'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'Trabalho',
      'totalVotes': 89,
      'votesA': 34,
      'votesB': 66,
      'expiresIn': 'expirado',
      'status': 'completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Ativos'),
            Tab(text: 'Meus Stories'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StoryCreationPage()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveStoriesTab(),
          _buildMyStoriesTab(),
        ],
      ),
    );
  }

  Widget _buildActiveStoriesTab() {
    return _activeStories.isEmpty
        ? _buildEmptyState(
      icon: Icons.timelapse,
      title: 'Nenhum story ativo no momento',
      description: 'Fique de olho! Novos pedidos de ajuda aparecem aqui frequentemente.',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeStories.length,
      itemBuilder: (context, index) {
        final story = _activeStories[index];
        return _buildActiveStoryCard(story);
      },
    );
  }

  Widget _buildMyStoriesTab() {
    return _myStories.isEmpty
        ? _buildEmptyState(
      icon: Icons.history,
      title: 'Você ainda não criou nenhum story',
      description: 'Crie um story emergencial para receber ajuda rápida na escolha de looks.',
      buttonText: 'Criar Story',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StoryCreationPage()),
        );
      },
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myStories.length,
      itemBuilder: (context, index) {
        final story = _myStories[index];
        return _buildMyStoryCard(story);
      },
    );
  }

  Widget _buildActiveStoryCard(Map<String, dynamic> story) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryViewPage(
              storyData: story,
              canVote: !story['hasVoted'],
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(story['userAvatar']),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story['username'],
                        style: TextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${story['eventTag']}',
                              style: TextStyles.tag,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${story['remainingMinutes']} min',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                story['question'],
                style: TextStyles.bodyLarge,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStoryImage(
                    story['imageUrls'][0],
                    'A',
                    story['hasVoted'] ? '${story['votesA']}%' : null,
                    story['hasVoted'] && story['votesA'] > story['votesB'],
                    null,
                  ),
                ),
                Expanded(
                  child: _buildStoryImage(
                    story['imageUrls'][1],
                    'B',
                    story['hasVoted'] ? '${story['votesB']}%' : null,
                    story['hasVoted'] && story['votesB'] > story['votesA'],
                    null,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.how_to_vote,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${story['totalVotes']} votos',
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (!story['hasVoted'])
                    Text(
                      'Toque para votar',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyStoryCard(Map<String, dynamic> story) {
    final bool isActive = story['status'] == 'active';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com pergunta e status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    story['question'],
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Ativo' : 'Finalizado',
                    style: TextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Imagens
          Row(
            children: [
              Expanded(
                child: _buildStoryImage(
                  story['imageUrls'][0],
                  'A',
                  '${story['votesA']}%',
                  story['votesA'] > story['votesB'],
                  null,
                ),
              ),
              Expanded(
                child: _buildStoryImage(
                  story['imageUrls'][1],
                  'B',
                  '${story['votesB']}%',
                  story['votesB'] > story['votesA'],
                  null,
                ),
              ),
            ],
          ),

          // Informações - divididas em duas linhas para evitar overflow
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primeira linha: Tag e votos
                Row(
                  children: [
                    // Tag com tamanho flexível
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${story['eventTag']}',
                          style: TextStyles.tag,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Contagem de votos
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.how_to_vote,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${story['totalVotes']} votos',
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Segunda linha: tempo restante ou botão de excluir
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isActive) ...[
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expira em ${story['expiresIn']}',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ] else
                      TextButton(
                        onPressed: () {
                          // Lógica para excluir o story
                          setState(() {
                            _myStories.removeWhere((s) => s == story);
                          });
                        },
                        child: const Text('Excluir'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage(
      String imageUrl,
      String label,
      String? votePercentage,
      bool isWinning,
      VoidCallback? onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: votePercentage != null && !isWinning
                ? ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            )
                : null,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: label == 'A' ? AppColors.primary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (votePercentage != null)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    votePercentage,
                    style: TextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (isWinning)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Preferido',
                          style: TextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (onTap != null)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTap,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: AppColors.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 32),
              AppButton(
                text: buttonText,
                isGradient: true,
                onPressed: onPressed,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
