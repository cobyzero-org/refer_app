import 'package:flutter/material.dart';
import 'package:refer_app/core/constants/app_constants.dart';
import 'package:refer_app/core/utils/widgets/app_button.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingHorizontal,
        vertical: AppConstants.paddingVertical,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Ya sabes que vas a pedir?',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.3,
            ),
          ),
          Text(
            'Inicia sesión o regístrate para ganar beneficios exclusivos con rewards para nuestros miembros rewards. Gana premios comprando productos favoritos.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            onPressed: () {},
            title: 'Iniciar sesión',
            color: theme.colorScheme.primary,
          ),
          AppButton(
            onPressed: () {},
            title: 'Regístrate',
            color: theme.colorScheme.surface,
            borderColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
