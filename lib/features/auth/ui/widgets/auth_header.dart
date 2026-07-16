import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../../core/theme.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AuthHeader({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 20),
        Text(
          title ?? l10n.welcomeBack,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle ?? l10n.welcomeSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.coffee, size: 60, color: AppColors.primary),
        ),
      ),
    );
  }
}
