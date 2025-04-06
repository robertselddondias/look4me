import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class StoryBubble extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final bool isViewed;
  final bool isActive;
  final VoidCallback onTap;
  final int remainingMinutes;

  const StoryBubble({
    Key? key,
    required this.username,
    required this.avatarUrl,
    this.isViewed = false,
    this.isActive = false,
    required this.onTap,
    this.remainingMinutes = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isViewed
                    ? null
                    : AppColors.storyGradient,
                color: isViewed ? Colors.grey.shade300 : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    if (isActive)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              "$remainingMinutes",
                              style: TextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              username,
              style: TextStyles.bodySmall.copyWith(
                fontWeight: isViewed ? FontWeight.normal : FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
