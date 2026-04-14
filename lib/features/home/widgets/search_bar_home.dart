import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Use l10n.searchHint once generation is complete, fallback to image text
    final hintText = 'Search for coffee, tea, or treats...';

    return InkWell(
      onTap: () => context.push('/search'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Color(0xFF2D3132),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText,
                style: const TextStyle(
                  color: Color(0xFF919999),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.tune_rounded,
              color: Color(0xFF2D3132),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
