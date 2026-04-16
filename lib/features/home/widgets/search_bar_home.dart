import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hintText = l10n.searchHint;

    return InkWell(
      onTap: () => context.push('/search'),
      borderRadius: BorderRadius.circular(24),
      child: Hero(
        tag: 'search_bar',
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F9),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            borderRadius: BorderRadius.circular(16),
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
            ],
          ),
        ),
      ),
    );
  }
}
