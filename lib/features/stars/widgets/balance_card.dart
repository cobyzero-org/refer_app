import 'package:flutter/material.dart';
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
    final double progress = nextRewardStars > 0
        ? (stars / nextRewardStars).clamp(0.0, 1.0)
        : 0.0;
    final int percentage = (progress * 100).toInt();
    final int remaining = nextRewardStars - stars > 0
        ? nextRewardStars - stars
        : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.currentBalance,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white54,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$stars",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 56,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.stars,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildCenterGauge(progress, percentage),
          const SizedBox(height: 48),
          Text(
            AppLocalizations.of(
              context,
            )!.starsRemaining(remaining, nextRewardName),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildLinearProgress(progress),
        ],
      ),
    );
  }

  Widget _buildCenterGauge(double progress, int percentage) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD4E9E2),
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars, color: Color(0xFFD4E9E2), size: 28),
              const SizedBox(height: 4),
              Text(
                "$percentage%",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD4E9E2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
