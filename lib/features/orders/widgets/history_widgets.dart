import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class OrderHistoryHeader extends StatelessWidget {
  const OrderHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.yourCollection,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.pastExperiences,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0C211B),
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class MonthlyDivider extends StatelessWidget {
  final String label;
  const MonthlyDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        children: [
          Expanded(
            child: Container(height: 1, color: Colors.grey.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Container(height: 1, color: Colors.grey.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }
}

class DetailedOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const DetailedOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    final createdAt = DateTime.parse(order['createdAt']);
    final dateStr = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    ).format(createdAt);
    final priceStr = '\$${order['total'].toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D3132),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(status, context),
                ],
              ),
              const Spacer(),
              Text(
                priceStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C211B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildProductStack()),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3932),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.reorder,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    Color color;
    String label;
    IconData icon;

    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'ORDERED':
        color = Colors.orange;
        label = l10n.statusOrdered;
        icon = Icons.shopping_basket_rounded;
        break;
      case 'PREPARING':
        color = Colors.blue;
        label = l10n.statusPreparing;
        icon = Icons.coffee_maker_rounded;
        break;
      case 'READY':
        color = Colors.green;
        label = l10n.statusReady;
        icon = Icons.check_circle_rounded;
        break;
      case 'COMPLETED':
        color = Colors.grey;
        label = l10n.statusCompleted;
        icon = Icons.done_all_rounded;
        break;
      case 'CANCELLED':
        color = Colors.red;
        label = l10n.statusCancelled;
        icon = Icons.cancel_rounded;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info_rounded;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductStack() {
    final List<dynamic> items = order['items'] ?? [];
    const int maxDisplay = 3;
    final int displayCount = items.length > maxDisplay
        ? maxDisplay + 1
        : items.length;
    final double stackWidth = 48.0 + (displayCount - 1) * 20.0;

    return SizedBox(
      height: 48,
      width: stackWidth,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          for (int i = 0; i < items.length && i < maxDisplay; i++)
            Positioned(
              left: i * 20.0,
              child: _buildCircularImage(items[i]['imageUrl'] ?? ''),
            ),
          if (items.length > maxDisplay)
            Positioned(
              left: maxDisplay * 20.0,
              child: _buildMoreIndicator(items.length - maxDisplay),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularImage(String url) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFD4E9E2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.coffee_rounded,
                color: Color(0xFF1E3932),
                size: 20,
              ),
            )
          : const Icon(
              Icons.coffee_rounded,
              color: Color(0xFF1E3932),
              size: 20,
            ),
    );
  }

  Widget _buildMoreIndicator(int count) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class MonthlySummaryCard extends StatelessWidget {
  final String text;
  const MonthlySummaryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.viewFullMonth,
                style: const TextStyle(
                  color: Color(0xFF0C211B),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleOrderRow extends StatelessWidget {
  final String date;
  final String description;
  final String price;

  const SimpleOrderRow({
    super.key,
    required this.date,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E9E2).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.coffee_rounded,
              color: Color(0xFF1E3932),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$description • $price',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.replay_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
