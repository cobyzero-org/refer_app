import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';

class ActiveOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const ActiveOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    final orderNumber = order['orderNumber'] ?? 'N/A';
    final List<dynamic> items = order['items'] ?? [];
    double progressWidth = 0.33;
    if (status == 'PREPARING') progressWidth = 0.66;
    if (status == 'READY') progressWidth = 1.0;

    return Semantics(
      container: true,
      label: 'Order $orderNumber, ${_getStatusLabel(context, status)}',
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              height: 96, width: double.infinity,
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_getStatusColor(status), _getStatusColor(status).withValues(alpha: 0.75)])),
              child: Center(child: Icon(_getStatusIcon(status), size: 36, color: Colors.white)),
            ),
            Positioned(bottom: 10, left: 12, child: Row(children: [
              if (items.isNotEmpty) _SmallProductCircle(imageUrl: items[0]['imageUrl']),
              if (items.length > 1) ...[const SizedBox(width: 4), _SmallProductCircle(count: '+${items.length - 1}')],
            ])),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(status == 'READY' ? Icons.check_circle_rounded : Icons.coffee_maker_outlined, size: 14, color: status == 'READY' ? AppColors.success : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(_getStatusLabel(context, status), style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: status == 'READY' ? AppColors.success : AppColors.textSecondary, letterSpacing: 0.6)),
              ]),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context)!.orderNumber(orderNumber.toString()), style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.text)),
              const SizedBox(height: 10),
              ...items.take(2).map((item) => Padding(padding: const EdgeInsets.only(bottom: 6), child: _OrderItem(title: '${item['quantity']}x ${item['name']}', subtitle: '${item['size'] ?? ''} ${item['type'] ?? ''}'.trim()))),
              const SizedBox(height: 14),
              _OrderProgressBar(widthFactor: progressWidth),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _StepLabel(label: AppLocalizations.of(context)!.statusOrdered, isActive: true),
                _StepLabel(label: AppLocalizations.of(context)!.statusBrewing, isActive: status == 'PREPARING' || status == 'READY'),
                _StepLabel(label: AppLocalizations.of(context)!.statusReady, isActive: status == 'READY'),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ORDERED': return const Color(0xFFD97706);
      case 'PREPARING': return const Color(0xFF2563EB);
      case 'READY': return AppColors.success;
      default: return AppColors.textTertiary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ORDERED': return Icons.shopping_basket_rounded;
      case 'PREPARING': return Icons.coffee_maker_rounded;
      case 'READY': return Icons.check_circle_rounded;
      default: return Icons.info_rounded;
    }
  }

  String _getStatusLabel(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'ORDERED': return l10n.statusOrdered;
      case 'PREPARING': return l10n.statusPreparing;
      case 'READY': return l10n.statusReady;
      default: return status.replaceAll('_', ' ');
    }
  }
}

class _OrderItem extends StatelessWidget {
  final String title; final String subtitle;
  const _OrderItem({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.text)),
    if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12.5)),
  ]);
}

class _OrderProgressBar extends StatelessWidget {
  final double widthFactor;
  const _OrderProgressBar({required this.widthFactor});
  @override
  Widget build(BuildContext context) => Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: AppColors.separator, borderRadius: BorderRadius.circular(999)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: widthFactor, child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)))));
}

class _StepLabel extends StatelessWidget {
  final String label; final bool isActive;
  const _StepLabel({required this.label, required this.isActive});
  @override
  Widget build(BuildContext context) => Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: isActive ? AppColors.text : AppColors.textTertiary, letterSpacing: 0.5));
}

class _SmallProductCircle extends StatelessWidget {
  final String? imageUrl; final String? count;
  const _SmallProductCircle({this.imageUrl, this.count});
  @override
  Widget build(BuildContext context) {
    if (count != null) {
      return Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), color: AppColors.primary), child: Center(child: Text(count!, style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))));
    }
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), color: AppColors.neutralGrouped, image: imageUrl != null && imageUrl!.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null),
      child: (imageUrl == null || imageUrl!.isEmpty) ? const Icon(Icons.coffee_rounded, size: 18, color: AppColors.primary) : null,
    );
  }
}
