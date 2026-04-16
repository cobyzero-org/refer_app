import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../repository/orders_repository.dart';
import '../widgets/history_widgets.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3932)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.orderHistory,
          style: const TextStyle(
            color: Color(0xFF1E3932),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: sl<OrdersRepository>().getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(AppLocalizations.of(context)!.errorLoadingOrders),
            );
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noOrdersFound),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OrderHistoryHeader(),
                MonthlyDivider(label: AppLocalizations.of(context)!.thisMonth),
                ...orders.map((order) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DetailedOrderCard(order: order),
                  );
                }).toList(),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
