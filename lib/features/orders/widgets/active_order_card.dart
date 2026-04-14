import 'package:flutter/material.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image Section
          Stack(
            children: [
              Image.network(
                'https://picsum.photos/seed/order1/600/300', // Placeholder
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    _SmallProductCircle(imageUrl: 'https://picsum.photos/seed/p1/50/50'),
                    const SizedBox(width: 4),
                    _SmallProductCircle(count: '+1'),
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
                    const Icon(Icons.coffee_maker_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'IN PREPARATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Order #8824',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                _OrderItem(
                  title: '1x Cascara Cold Brew',
                  subtitle: 'Customized with oat milk, organic agave',
                ),
                const SizedBox(height: 8),
                _OrderItem(
                  title: '1x Almond Croissant',
                  subtitle: 'Warmed',
                ),
                const SizedBox(height: 24),
                // Progress Bar
                const _OrderProgressBar(currentStep: 1),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StepLabel(label: 'ORDERED', isActive: true),
                    _StepLabel(label: 'BREWING', isActive: true),
                    _StepLabel(label: 'READY', isActive: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  final int currentStep;
  const _OrderProgressBar({required this.currentStep});

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
        widthFactor: 0.66, // 2/3 of the way
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
          : Image.network(imageUrl!, fit: BoxFit.cover),
    );
  }
}
