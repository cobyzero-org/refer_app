import 'package:flutter/material.dart';
import '../../../core/theme.dart';

import '../models/reward.dart';
import '../../../core/utils/icon_mapper.dart';

class RewardRedeemCard extends StatelessWidget {
  final Reward reward;
  final bool isDark;
  final VoidCallback? onTap;

  const RewardRedeemCard({
    super.key,
    required this.reward,
    this.isDark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.primary : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFD4E9E2).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: reward.imageUrl != null && reward.imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        reward.imageUrl!,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          IconMapper.getIcon(reward.icon),
                          color: isDark ? const Color(0xFFD4E9E2) : AppColors.primary,
                          size: 24,
                        ),
                      ),
                    )
                  : Icon(
                      IconMapper.getIcon(reward.icon),
                      color: isDark ? const Color(0xFFD4E9E2) : AppColors.primary,
                      size: 24,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              "${reward.starsRequired} Stars",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                reward.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
