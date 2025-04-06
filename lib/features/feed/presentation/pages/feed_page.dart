import 'package:flutter/material.dart';
import 'package:look4me_app/core/theme/app_colors.dart';
import 'package:look4me_app/core/theme/text_styles.dart';
import 'package:look4me_app/core/widgets/look_card.dart';
import 'package:look4me_app/core/widgets/story_bubble.dart';
import 'package:look4me_app/features/feed/presentation/widgets/category_chip.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<String> _categories = [
    'Para você',
    'Populares',
    'Seguindo',
    'Casual',
    'Formal',
    'Festa',
    'Trabalho',
  ];

  int _selectedCategoryIndex = 0;

  // Dados mockados para os stories
  final List<Map<String, dynamic>> _storiesData = [
    {
      'username': 'minha_história',
      'avatarUrl': 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': false,
      'isActive': false,
      'remainingMinutes': 0,
    },
    {
      'username': 'maria_style',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': false,
      'isActive': true,
      'remainingMinutes': 15,
    },
    {
      'username': 'fashion_julia',
      'avatarUrl': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': false,
      'isActive': true,
      'remainingMinutes': 8,
    },
    {
      'username': 'style_ana',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': true,
      'isActive': false,
      'remainingMinutes': 0,
    },
    {
      'username': 'laura_moda',
      'avatarUrl': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': false,
      'isActive': true,
      'remainingMinutes': 20,
    },
    {
      'username': 'luiza_looks',
      'avatarUrl': 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'isViewed': true,
      'isActive': false,
      'remainingMinutes': 0,
    },
  ];

  // Dados mockados para os cards de looks
  final List<Map<String, dynamic>> _postsData = [
    {
      'username': 'maria_style',
      'userAvatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'JantarComAmigos',
      'votes': [65, 35],
      'hasVoted': true,
      'brandName': 'Zara',
      'showBadge': true,
      'badgeType': 'fashion_expert',
    },
    {
      'username': 'fashion_julia',
      'userAvatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1529903384065-b623f72add75?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'EntrevistaDeEmprego',
      'votes': [48, 52],
      'hasVoted': false,
      'showBadge': true,
      'badgeType': 'trendsetter',
    },
    {
      'username': 'style_ana',
      'userAvatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=256&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
        'https://images.unsplash.com/photo-1496747611176-843222e1e57c?ixlib=rb-1.2.1&auto=format&fit=crop&w=512&q=80',
      ],
      'eventTag': 'CasamentoNoJardim',
      'votes': [27, 73],
      'hasVoted': true,
      'brandName': 'H&M',
      'showBadge': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Look',
              style: TextStyles.heading2.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '4Me',
              style: TextStyles.heading2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _storiesData.length,
                  itemBuilder: (context, index) {
                    final storyData = _storiesData[index];
                    return StoryBubble(
                      username: storyData['username'],
                      avatarUrl: storyData['avatarUrl'],
                      isViewed: storyData['isViewed'],
                      isActive: storyData['isActive'],
                      remainingMinutes: storyData['remainingMinutes'],
                      onTap: () {
                        // Navegar para a tela de visualização de stories
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    title: _categories[index],
                    isSelected: _selectedCategoryIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final postData = _postsData[index];
                return LookCard(
                  username: postData['username'],
                  userAvatar: postData['userAvatar'],
                  imageUrls: List<String>.from(postData['imageUrls']),
                  eventTag: postData['eventTag'],
                  votes: List<int>.from(postData['votes']),
                  hasVoted: postData['hasVoted'],
                  onVote: (index) {
                    // Implementar voto
                    setState(() {
                      _postsData[index]['hasVoted'] = true;
                    });
                  },
                  brandName: postData['brandName'],
                  showBadge: postData['showBadge'],
                  badgeType: postData['badgeType'],
                );
              },
              childCount: _postsData.length,
            ),
          ),
        ],
      ),
    );
  }
}
