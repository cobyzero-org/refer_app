import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/cart_item.dart';

class OrderSummaryCard extends StatelessWidget {
  final double total;
  final int itemCount;
  final double serviceFee;
  final List<CartItem> items;

  const OrderSummaryCard({
    super.key,
    required this.total,
    required this.itemCount,
    required this.serviceFee,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderSummary,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$itemCount items',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(l10n.subtotal, '\$${total.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow(
            l10n.serviceFee,
            '\$${serviceFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '\$${(total + serviceFee).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3932),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDecorativeCard(context),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3932),
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeCard(BuildContext context) {
    final totalStars = items.fold<int>(
      0,
      (sum, item) => sum + item.starsReward,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3932).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E3932).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: Color(0xFF1E3932)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '¡Estás ganando $totalStars estrellas con este pedido!',
              style: const TextStyle(
                color: Color(0xFF1E3932),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
