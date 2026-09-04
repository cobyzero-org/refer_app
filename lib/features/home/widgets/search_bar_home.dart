import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: 'Search',
      hint: 'Search for coffee, tea, or treats',
      child: InkWell(
        onTap: () => context.push('/search'),
        borderRadius: BorderRadius.circular(12),
        child: Hero(
          tag: 'search_bar',
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.separator, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.searchHint,
                    style: GoogleFonts.outfit(
                      color: AppColors.textTertiary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: AppColors.neutralGrouped,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.north_west_rounded, size: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
