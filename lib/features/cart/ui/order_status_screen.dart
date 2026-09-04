import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

class OrderStatusScreen extends StatelessWidget {
  final String orderId; final String locationName;
  const OrderStatusScreen({super.key, required this.orderId, required this.locationName});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text), onPressed: () => context.go('/main'), style: IconButton.styleFrom(minimumSize: const Size(44,44))), title: Text(l10n.orderStatusTitle, style: GoogleFonts.outfit(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: -0.2)), centerTitle: true),
      body: SafeArea(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 28),
        Center(child: Stack(alignment: Alignment.center, children: [
          Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.06))),
          Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.10))),
          Container(width: 88, height: 88, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF0C211B)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 40)),
        ])),
        const SizedBox(height: 24),
        Text(l10n.orderIsReady, textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3, height: 1.2)),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.primary.withValues(alpha: 0.14))), child: Text(l10n.orderNumber(orderId), style: GoogleFonts.outfit(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w700, letterSpacing: 0.3))),
        const SizedBox(height: 24),
        Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20), const SizedBox(width: 8), Flexible(child: Text(locationName, style: GoogleFonts.outfit(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))]),
          const Divider(height: 24, color: AppColors.separator),
          Text(l10n.pickupInstructions, textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
        ])),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: () => context.go('/main'), style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.backToHome, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 24),
      ])))),
    );
  }
}
