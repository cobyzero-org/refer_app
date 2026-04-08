import 'package:flutter/material.dart';
import 'package:refer_app/features/stars/widgets/balance_card.dart';
import 'package:refer_app/features/stars/widgets/reward_redeem_card.dart';

class StarsScreen extends StatelessWidget {
  const StarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stars Rewards",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceCard(stars: 85),
            const SizedBox(height: 48),
            const Text(
              "Redeem your Stars",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                RewardRedeemCard(
                  icon: Icons.add_circle_outline,
                  stars: "25",
                  description: "Extra Espresso Shot",
                ),
                RewardRedeemCard(
                  icon: Icons.bakery_dining_rounded,
                  stars: "50",
                  description: "Fresh Bakery Item",
                ),
                RewardRedeemCard(
                  icon: Icons.local_cafe_rounded,
                  stars: "100",
                  description: "Handcrafted Drink",
                  isDark: true,
                ),
                RewardRedeemCard(
                  icon: Icons.lunch_dining_rounded,
                  stars: "200",
                  description: "Lunch Sandwich",
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Text(
              "Earning & Perks",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            _buildFeaturedPerk(),
            const SizedBox(height: 16),
            _buildSimplePerk(
              icon: Icons.celebration_rounded,
              title: "Birthday Treat",
              description:
                  "On your special day, the roast is on us. Enjoy any handcrafted beverage or food item for free.",
            ),
            const SizedBox(height: 16),
            _buildSimplePerk(
              icon: Icons.auto_awesome_rounded,
              title: "Early Access",
              description:
                  "Be the first to taste our seasonal limited-edition beans before they hit the general public.",
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                TextButton(onPressed: () {}, child: const Text("View History")),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              title: "Ethical Blend Pour-over",
              subtitle: "Yesterday • Downtown Roast",
              stars: "+12 Stars",
            ),
            const Divider(height: 32),
            _buildActivityItem(
              title: "Avocado Toast & Flat White",
              subtitle: "Nov 22 • West End Roast",
              stars: "+34 Stars",
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPerk() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/perks_latte.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "2 Stars per \$1",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Pay with your registered digital roast card to earn stars twice as fast.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplePerk({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String stars,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: Colors.black54,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          stars,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ],
    );
  }
}
