import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';

class OrderHistoryHeader extends StatelessWidget {
  const OrderHistoryHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.yourCollection, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.8)),
      const SizedBox(height: 6),
      Text(AppLocalizations.of(context)!.pastExperiences, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.15, letterSpacing: -0.5)),
    ]);
  }
}

class MonthlyDivider extends StatelessWidget {
  final String label;
  const MonthlyDivider({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Row(children: [
      Expanded(child: Container(height: 1, color: AppColors.separator)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(label.toUpperCase(), style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 1.2))),
      Expanded(child: Container(height: 1, color: AppColors.separator)),
    ]),
  );
}

class DetailedOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const DetailedOrderCard({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    final createdAt = DateTime.parse(order['createdAt']);
    final dateStr = DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(createdAt);
    final priceStr = Money.format((order['total'] as num).toDouble());
    return Semantics(
      button: true, label: 'Order $dateStr $priceStr',
      child: InkWell(
        onTap: () => context.push('/order-detail', extra: order),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(dateStr, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text)),
                const SizedBox(height: 4), _buildStatusBadge(status, context),
              ]),
              const Spacer(),
              Text(priceStr, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
            ]),
            const SizedBox(height: 16), _buildProductStack(),
          ]),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    Color color; String label; IconData icon;
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'ORDERED': color = const Color(0xFFD97706); label = l10n.statusOrdered; icon = Icons.shopping_basket_rounded; break;
      case 'PREPARING': color = const Color(0xFF2563EB); label = l10n.statusPreparing; icon = Icons.coffee_maker_rounded; break;
      case 'READY': color = AppColors.success; label = l10n.statusReady; icon = Icons.check_circle_rounded; break;
      case 'COMPLETED': color = AppColors.textSecondary; label = l10n.statusCompleted; icon = Icons.done_all_rounded; break;
      case 'CANCELLED': color = AppColors.error; label = l10n.statusCancelled; icon = Icons.cancel_rounded; break;
      default: color = AppColors.textTertiary; label = status; icon = Icons.info_rounded;
    }
    return Row(children: [Icon(icon, color: color, size: 12), const SizedBox(width: 4), Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5))]);
  }

  Widget _buildProductStack() {
    final List<dynamic> items = order['items'] ?? [];
    const int maxDisplay = 3;
    final int displayCount = items.length > maxDisplay ? maxDisplay + 1 : items.length;
    final double stackWidth = 44.0 + (displayCount - 1) * 18.0;
    return SizedBox(
      height: 44, width: stackWidth,
      child: Stack(alignment: Alignment.centerLeft, children: [
        for (int i = 0; i < items.length && i < maxDisplay; i++) Positioned(left: i * 18.0, child: _buildCircularImage(items[i]['imageUrl'] ?? '')),
        if (items.length > maxDisplay) Positioned(left: maxDisplay * 18.0, child: _buildMoreIndicator(items.length - maxDisplay)),
      ]),
    );
  }

  Widget _buildCircularImage(String url) => Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), image: url.isNotEmpty ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover) : null));
  Widget _buildMoreIndicator(int count) => Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.neutralGrouped, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), alignment: Alignment.center, child: Text('+$count', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)));
}

class MonthlySummaryCard extends StatelessWidget {
  final String text;
  const MonthlySummaryCard({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
    child: Column(children: [
      Text(text, textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context)!.viewFullMonth, style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(width: 6), const Icon(Icons.arrow_forward_rounded, color: AppColors.textTertiary, size: 14),
      ]),
    ]),
  );
}

class SimpleOrderRow extends StatelessWidget {
  final String date; final String description; final String price;
  const SimpleOrderRow({super.key, required this.date, required this.description, required this.price});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.coffee_rounded, color: AppColors.primary, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(date, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
        const SizedBox(height: 2), Text('$description • $price', style: GoogleFonts.outfit(color: AppColors.textTertiary, fontSize: 12)),
      ])),
      Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: AppColors.neutralGrouped, shape: BoxShape.circle), child: const Icon(Icons.replay_rounded, color: AppColors.textTertiary, size: 18)),
    ]),
  );
}
