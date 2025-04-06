import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class LookCard extends StatefulWidget {
  final String username;
  final String userAvatar;
  final List<String> imageUrls;
  final String eventTag;
  final List<int> votes;
  final bool hasVoted;
  final Function(int)? onVote;
  final String? brandName;
  final bool showBadge;
  final String? badgeType;

  const LookCard({
    Key? key,
    required this.username,
    required this.userAvatar,
    required this.imageUrls,
    required this.eventTag,
    required this.votes,
    this.hasVoted = false,
    this.onVote,
    this.brandName,
    this.showBadge = false,
    this.badgeType,
  }) : super(key: key);

  @override
  State<LookCard> createState() => _LookCardState();
}

class _LookCardState extends State<LookCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleVote(int index) {
    if (widget.hasVoted || widget.onVote == null) return;

    setState(() {
      _selectedIndex = index;
    });

    _animationController.forward().then((_) {
      widget.onVote?.call(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildLookImages(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userAvatar),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.username,
                    style: TextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (widget.showBadge) ...[
                    const SizedBox(width: 4),
                    _buildBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "#${widget.eventTag}",
                  style: TextStyles.tag,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (widget.badgeType) {
      case 'fashion_expert':
        badgeColor = Colors.amber;
        badgeText = "Fashion Expert";
        badgeIcon = Icons.auto_awesome;
        break;
      case 'trendsetter':
        badgeColor = AppColors.secondary;
        badgeText = "Trendsetter";
        badgeIcon = Icons.trending_up;
        break;
      default:
        badgeColor = AppColors.primary;
        badgeText = "Style Guru";
        badgeIcon = Icons.star;
    }

    return Tooltip(
      message: badgeText,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          badgeIcon,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }

  Widget _buildLookImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          widget.imageUrls.length,
              (index) => Expanded(
            child: GestureDetector(
              onTap: () => _handleVote(index),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_selectedIndex != null) {
                    scale = _selectedIndex == index
                        ? 1.0 + (0.05 * _animation.value)
                        : 1.0 - (0.05 * _animation.value);
                  }

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      height: 300,
                      margin: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: _selectedIndex == index ? 0 : 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(widget.imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                        border: _selectedIndex == index
                            ? Border.all(color: AppColors.primary, width: 3)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          if (widget.hasVoted)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${widget.votes[index]}%",
                                  style: TextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.brandName != null && index == 0)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.brandName!,
                                  style: TextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final int totalVotes = widget.votes.fold(0, (a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            widget.hasVoted ? "$totalVotes votes" : "Vote now!",
            style: TextStyles.bodyMedium,
          ),
          const Spacer(),
          Icon(
            Icons.bookmark_border,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.share_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
