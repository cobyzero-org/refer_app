import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class RewardRedeemCard extends StatelessWidget {
  final IconData icon;
  final String stars;
  final String description;
  final bool isDark;

  const RewardRedeemCard({
    super.key,
    required this.icon,
    required this.stars,
    required this.description,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Icon(
              icon,
              color: isDark ? const Color(0xFFD4E9E2) : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "$stars Stars",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
