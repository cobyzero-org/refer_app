import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';

class BalanceCard extends StatelessWidget {
  final int stars;

  const BalanceCard({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
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
          _buildCenterGauge(),
          const SizedBox(height: 48),
          Text(
            AppLocalizations.of(context)!.starsRemaining(
              100 - stars > 0 ? 100 - stars : 0,
              "Artisanal Brew",
            ),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildLinearProgress(),
        ],
      ),
    );
  }

  Widget _buildCenterGauge() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: CircularProgressIndicator(
              value: 0.85,
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
                "85%",
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

  Widget _buildLinearProgress() {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.85,
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
