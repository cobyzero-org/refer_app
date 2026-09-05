import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/theme.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../model/cart_item.dart';
import '../../../core/di.dart';
import '../../../core/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      bloc: sl<CartBloc>(),
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        List<CartItem> items = [];
        double total = 0;
        if (state is CartLoaded) { items = state.items; total = state.total; }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0,
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text), onPressed: () => context.pop(), style: IconButton.styleFrom(minimumSize: const Size(44,44))),
            title: Text(l10n.yourOrder, style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.2)),
            centerTitle: true,
            actions: [IconButton(icon: const Icon(Icons.shopping_bag_rounded, color: AppColors.text), onPressed: () {}, style: IconButton.styleFrom(minimumSize: const Size(44,44)))],
          ),
          body: items.isEmpty && state is! CartLoading
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.textTertiary), const SizedBox(height: 12),
                  Text(l10n.cartEmpty, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ])))
              : Stack(children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(l10n.reviewSelection, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3)),
                        Text(l10n.itemsCount(items.length), style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 16),
                      ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildCartItem(context, item: item))),
                      if (items.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.neutralGrouped, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
                          child: Column(children: [
                            _buildSummaryRow(l10n.subtotal, Money.format(total)),
                            if (TaxConfig.enabled) ...[
                              const SizedBox(height: 8),
                              _buildSummaryRow('${l10n.estimatedTax} (${TaxConfig.percentLabel})', Money.format(total * TaxConfig.effectiveRate)),
                            ],
                            const Divider(height: 24, color: AppColors.separator),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(l10n.total, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                              Text(Money.format(TaxConfig.applyTo(total)), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ]),
                          ]),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.secondary)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(l10n.cartInfoMessage, style: GoogleFonts.outfit(fontSize: 12, height: 1.5, color: AppColors.primary, fontWeight: FontWeight.w500))),
                        ]),
                      ),
                      const SizedBox(height: 88),
                    ]),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: FilledButton(
                      onPressed: () => context.push('/checkout'),
                      style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(l10n.go_to_checkout, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(width: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)), child: Text(Money.format(TaxConfig.applyTo(total)), style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
                      ]),
                    ))),
                  ),
                ]),
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, {required CartItem item}) {
    String options = "";
    if (item.size != null) options += "${item.size}, ";
    if (item.type != null) options += "${item.type}, ";
    options += item.enhancements.join(", ");
    if (options.endsWith(", ")) options = options.substring(0, options.length - 2);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item.imageUrl, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width:72,height:72,color:AppColors.neutralGrouped,child: const Icon(Icons.coffee_rounded, color: AppColors.textTertiary)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(item.name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text))),
            Text(Money.format(item.unitPrice), style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
          ]),
          const SizedBox(height: 2),
          Text(options, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 30, decoration: BoxDecoration(color: AppColors.neutralGrouped, borderRadius: BorderRadius.circular(999)), child: Row(mainAxisSize: MainAxisSize.min, children: [
              _qtyBtn(Icons.remove_rounded, () => sl<CartBloc>().add(CartItemQuantityUpdated(item.id, item.quantity - 1))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("${item.quantity}", style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13))),
              _qtyBtn(Icons.add_rounded, () => sl<CartBloc>().add(CartItemQuantityUpdated(item.id, item.quantity + 1))),
            ])),
            IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textTertiary, size: 18), onPressed: () => sl<CartBloc>().add(CartRemoved(item.id)), style: IconButton.styleFrom(minimumSize: const Size(36,36)), tooltip: 'Remove'),
          ]),
        ])),
      ]),
    );
  }

  Widget _buildSummaryRow(String label, String value) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
    Text(value, style: GoogleFonts.outfit(fontSize: 13, color: AppColors.text, fontWeight: FontWeight.w700)),
  ]);

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(999), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: Icon(icon, size: 14, color: AppColors.textSecondary)));
}
