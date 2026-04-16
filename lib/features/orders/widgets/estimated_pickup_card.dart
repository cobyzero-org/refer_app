import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';

class EstimatedPickupCard extends StatelessWidget {
  const EstimatedPickupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3932), // Dark green
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFFD4E9E2), size: 28),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.estimatedPickup,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.estimatedPickupDetail,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
