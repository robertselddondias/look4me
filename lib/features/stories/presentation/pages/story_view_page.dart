// lib/features/stories/presentation/pages/story_view_page.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class StoryViewPage extends StatefulWidget {
  final Map<String, dynamic> storyData;
  final bool canVote;

  const StoryViewPage({
    super.key,
    required this.storyData,
    this.canVote = true,
  });

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  bool _hasVoted = false;
  int? _selectedOption;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _hasVoted = !widget.canVote;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleVote(int option) {
    if (_hasVoted) return;

    setState(() {
      _hasVoted = true;
      _selectedOption = option;

      // Atualizar votos no storyData (cópia local)
      final votesA = widget.storyData['votesA'];
      final votesB = widget.storyData['votesB'];

      if (option == 0) {
        widget.storyData['votesA'] = votesA + 1;
      } else {
        widget.storyData['votesB'] = votesB + 1;
      }
    });

    // Mostrar confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Seu voto foi registrado!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Conteúdo principal
            PageView(
              controller: _pageController,
              children: [
                _buildStoryView(0),
                _buildStoryView(1),
              ],
            ),

            // Cabeçalho
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.storyData['userAvatar'] ?? ''),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.storyData['username'] ?? 'Usuário',
                          style: TextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.storyData['remainingMinutes'] ?? 0} minutos restantes',
                          style: TextStyles.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // Indicadores de deslize
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: _pageController.hasClients && _pageController.page?.round() == 0
                          ? Colors.white
                          : Colors.white38,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: _pageController.hasClients && _pageController.page?.round() == 1
                          ? Colors.white
                          : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),

            // Pergunta
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.storyData['question'] ?? '',
                  style: TextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Tag do evento
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${widget.storyData['eventTag']}',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Informações de votação
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.how_to_vote,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.storyData['totalVotes']} votos',
                      style: TextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryView(int index) {
    final String imageUrl = widget.storyData['imageUrls'][index];
    final bool isOptionA = index == 0;
    final String label = isOptionA ? 'A' : 'B';
    final int votePercentage = isOptionA
        ? widget.storyData['votesA']
        : widget.storyData['votesB'];
    final bool isWinning = isOptionA
        ? widget.storyData['votesA'] > widget.storyData['votesB']
        : widget.storyData['votesB'] > widget.storyData['votesA'];

    return GestureDetector(
      onTap: widget.canVote && !_hasVoted ? () => _handleVote(index) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),

          // Overlay para escurecer a imagem
          Container(
            color: Colors.black.withOpacity(0.2),
          ),

          // Label da opção (A ou B)
          Positioned(
            top: 150,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isOptionA ? AppColors.primary : AppColors.secondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Opção $label',
                style: TextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Exibir percentagem de votos se já votou
          if (_hasVoted)
            Positioned(
              top: 200,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$votePercentage%',
                  style: TextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Selo de "Preferido" se esta opção estiver vencendo
          if (_hasVoted && isWinning)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Escolha Preferida',
                      style: TextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Instruções para votar
          if (!_hasVoted && widget.canVote)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Toque para votar nesta opção',
                    style: TextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Adiciona efeito de feedback ao tocar
          if (widget.canVote && !_hasVoted)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleVote(index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
