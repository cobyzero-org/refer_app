import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class RewardsCard extends StatelessWidget {
  final int stars;
  final double progress;
  final String nextRewardMessage;

  const RewardsCard({
    super.key,
    required this.stars,
    required this.progress,
    this.nextRewardMessage = "until your next free artisanal brew",
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Semantics(
      container: true,
      label: '$stars Stars, ${(clamped * 100).round()} percent to next reward. $nextRewardMessage',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          // Subtle depth — HIG Materials
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Star Rewards',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.72),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  semanticsLabel: 'Star Rewards',
                ),
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$stars',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Stars',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Semantics(
              label: 'Progress to next reward',
              value: '${(clamped * 100).round()} percent',
              child: _buildProgressBar(clamped),
            ),
            const SizedBox(height: 12),
            Text(
              nextRewardMessage,
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double clamped) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
