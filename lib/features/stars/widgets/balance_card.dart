import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';

class BalanceCard extends StatelessWidget {
  final int stars;
  final int nextRewardStars;
  final String nextRewardName;

  const BalanceCard({
    super.key,
    required this.stars,
    required this.nextRewardStars,
    required this.nextRewardName,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = nextRewardStars > 0 ? (stars / nextRewardStars).clamp(0.0, 1.0) : 0.0;
    final int percentage = (progress * 100).toInt();
    final int remaining = nextRewardStars - stars > 0 ? nextRewardStars - stars : 0;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      container: true,
      label: '$stars ${l10n.stars}, $percentage percent to $nextRewardName',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.18), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.currentBalance.toUpperCase(),
              style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.68), letterSpacing: 1.1, fontWeight: FontWeight.w600, fontSize: 11),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$stars', style: GoogleFonts.outfit(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700, letterSpacing: -1.2, height: 1)),
                const SizedBox(width: 8),
                Text(l10n.stars, style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.84), fontSize: 17, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 20),
            _buildCenterGauge(progress, percentage),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.starsRemaining(remaining, nextRewardName),
              style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.84), fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
            ),
            const SizedBox(height: 12),
            Semantics(label: 'Progress to next reward', value: '$percentage percent', child: _buildLinearProgress(progress)),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterGauge(double progress, int percentage) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 132,
            width: 132,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 26),
              const SizedBox(height: 4),
              Text('$percentage%', style: GoogleFonts.outfit(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinearProgress(double progress) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(999))),
      ),
    );
  }
}
