import 'package:flutter/material.dart';
import '../widgets/active_order_card.dart';
import '../widgets/estimated_pickup_card.dart';
import '../widgets/history_order_card.dart';
import '../widgets/orders_header.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // Hide app bar to use custom header
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OrdersHeader(),
            const SizedBox(height: 40),
            
            // Active Orders Section
            const SizedBox(height: 48),
            
            // Active Orders Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4E9E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '2 items',
                    style: TextStyle(
                      color: Color(0xFF1E3932),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const ActiveOrderCard(),
            const SizedBox(height: 16),
            const EstimatedPickupCard(),
            
            const SizedBox(height: 48),
            
            // Order History Section
            const Text(
              'Order History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            const HistoryOrderCard(
              date: 'OCT 14, 2023',
              orderId: '8712',
              title: 'Morning Roast & Pastry',
              price: '\$14.50',
              productNames: 'Smoked Vanilla Latte, Espresso Macchiato',
              imageUrls: [
                'https://picsum.photos/seed/p1/200/200',
                'https://picsum.photos/seed/p2/200/200',
              ],
            ),
            const HistoryOrderCard(
              date: 'OCT 10, 2023',
              orderId: '8645',
              title: 'Ethiopian Yirgacheffe (Whole Bean)',
              price: '\$22.00',
              productNames: '250g Retail Pack',
              isReorderAll: false,
              imageUrls: [
                'https://picsum.photos/seed/p3/200/200',
              ],
            ),
            const HistoryOrderCard(
              date: 'SEP 28, 2023',
              orderId: '8432',
              title: 'Office Run',
              price: '\$31.25',
              productNames: '4 items including Espresso Macchiato, Latte...',
              imageUrls: [
                'https://picsum.photos/seed/p4/200/200',
                'https://picsum.photos/seed/p5/200/200',
                'https://picsum.photos/seed/p6/200/200',
                'https://picsum.photos/seed/p7/200/200',
              ],
            ),
            
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View full archive (12)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
