import 'package:flutter/material.dart';
import 'package:refer_app/l10n/app_localizations.dart';

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

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Color Section
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getStatusColor(status),
                      _getStatusColor(status).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(status),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    if (items.isNotEmpty)
                      _SmallProductCircle(imageUrl: items[0]['imageUrl']),
                    if (items.length > 1) ...[
                      const SizedBox(width: 4),
                      _SmallProductCircle(count: '+${items.length - 1}'),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      status == 'READY'
                          ? Icons.check_circle_rounded
                          : Icons.coffee_maker_outlined,
                      size: 16,
                      color: status == 'READY' ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusLabel(context, status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: status == 'READY'
                            ? Colors.green
                            : Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.orderNumber(orderNumber.toString()),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...items
                    .take(2)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _OrderItem(
                          title: '${item['quantity']}x ${item['name']}',
                          subtitle:
                              '${item['size'] ?? ''} ${item['type'] ?? ''}',
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 24),
                // Progress Bar
                _OrderProgressBar(widthFactor: progressWidth),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StepLabel(
                      label: AppLocalizations.of(context)!.statusOrdered,
                      isActive: true,
                    ),
                    _StepLabel(
                      label: AppLocalizations.of(context)!.statusBrewing,
                      isActive: status == 'PREPARING' || status == 'READY',
                    ),
                    _StepLabel(
                      label: AppLocalizations.of(context)!.statusReady,
                      isActive: status == 'READY',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ORDERED':
        return Colors.orange;
      case 'PREPARING':
        return Colors.blue;
      case 'READY':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ORDERED':
        return Icons.shopping_basket_rounded;
      case 'PREPARING':
        return Icons.coffee_maker_rounded;
      case 'READY':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getStatusLabel(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'ORDERED':
        return l10n.statusOrdered;
      case 'PREPARING':
        return l10n.statusPreparing;
      case 'READY':
        return l10n.statusReady;
      default:
        return status.replaceAll('_', ' ');
    }
  }
}

class _OrderItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _OrderItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}

class _OrderProgressBar extends StatelessWidget {
  final double widthFactor;
  const _OrderProgressBar({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E3932), // Dark green
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String label;
  final bool isActive;
  const _StepLabel({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: isActive ? Colors.black : Colors.grey.shade400,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SmallProductCircle extends StatelessWidget {
  final String? imageUrl;
  final String? count;

  const _SmallProductCircle({this.imageUrl, this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: count != null ? const Color(0xFF1E3932) : Colors.grey.shade200,
      ),
      clipBehavior: Clip.antiAlias,
      child: count != null
          ? Center(
              child: Text(
                count!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : (imageUrl != null && imageUrl!.isNotEmpty)
          ? Image.network(
              imageUrl!,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.coffee_rounded,
                size: 20,
                color: Color(0xFF1E3932),
              ),
            )
          : const Icon(
              Icons.coffee_rounded,
              size: 20,
              color: Color(0xFF1E3932),
            ),
    );
  }
}
