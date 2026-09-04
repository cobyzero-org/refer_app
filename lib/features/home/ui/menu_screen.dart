import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/core/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../l10n/app_localizations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: Center(
          child: Container(
            height: 38,
            width: 38,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.separator, width: 1),
            ),
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              tooltip: 'Back',
              style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          l10n.viewMenu,
          style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.2),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.primary)));
          }
          if (state is HomeLoaded) {
            final featured =
                state.collections.expand((c) => c.products).toList();
            final latest = state.latestProducts;
            if (featured.isEmpty && latest.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.coffee_outlined, size: 40, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text(l10n.noSeasonalBrews, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final collection in state.collections) ...[
                    if (collection.products.isNotEmpty) ...[
                      Semantics(header: true, child: Text(collection.name, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3))),
                      const SizedBox(height: 14),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: collection.products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: 0.74),
                        itemBuilder: (context, index) => _buildMenuProductCard(context, collection.products[index]),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                  if (latest.isNotEmpty) ...[
                    Semantics(header: true, child: Text(l10n.recentProducts, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3))),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: latest.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: 0.74),
                      itemBuilder: (context, index) => _buildMenuProductCard(context, latest[index]),
                    ),
                  ],
                ],
              ),
            );
          }
          context.read<HomeBloc>().add(HomeDataRequested());
          return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.2)));
        },
      ),
    );
  }

  Widget _buildMenuProductCard(BuildContext context, Product product) {
    return Semantics(
      button: true,
      label: '${product.name}, ${Money.format(product.price)}',
      hint: 'View details',
      child: GestureDetector(
        onTap: () => context.push('/product/${product.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.separator, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.neutralGrouped,
                      child: const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textTertiary))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.neutralGrouped,
                      child: const Icon(Icons.coffee_rounded, size: 32, color: AppColors.textTertiary),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.text, height: 1.3, letterSpacing: -0.1), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Money.format(product.price), style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.text, letterSpacing: -0.1)),
                        if (product.rating > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.neutralGrouped, borderRadius: BorderRadius.circular(999)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 11),
                                const SizedBox(width: 3),
                                Text(product.rating.toStringAsFixed(1), style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.text)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
