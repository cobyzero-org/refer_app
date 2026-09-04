import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            AppLocalizations.of(context)!.yourRituals,
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.5, height: 1.2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.ritualsSubtitle,
          style: GoogleFonts.outfit(fontSize: 15, color: AppColors.textSecondary, height: 1.5, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
