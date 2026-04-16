import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/active_order_card.dart';
import '../widgets/estimated_pickup_card.dart';
import '../widgets/orders_header.dart';
import '../widgets/history_widgets.dart'; // To use DetailedOrderCard or similar if needed

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(OrdersStarted()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.orders,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersFailure) {
              return Center(child: Text(state.message));
            }

            if (state is OrdersLoaded) {
              final activeOrders = state.orders
                  .where(
                    (o) =>
                        ['ORDERED', 'PREPARING', 'READY'].contains(o['status']),
                  )
                  .toList();

              final completedOrders = state.orders
                  .where(
                    (o) => ['COMPLETED', 'CANCELLED'].contains(o['status']),
                  )
                  .take(3)
                  .toList(); // Show last 3

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const OrdersHeader(),

                    if (activeOrders.isNotEmpty) ...[
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activeOrders,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4E9E2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.activeCount(activeOrders.length),
                              style: const TextStyle(
                                color: Color(0xFF1E3932),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...activeOrders
                          .map(
                            (order) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ActiveOrderCard(order: order),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 16),
                      // Optional: Estimated pickup card could be dynamic based on the first active order
                      const EstimatedPickupCard(),
                    ],

                    const SizedBox(height: 48),
                    Text(
                      AppLocalizations.of(context)!.orderHistory,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (completedOrders.isEmpty)
                      Center(
                        child: Text(AppLocalizations.of(context)!.noHistoryYet),
                      )
                    else
                      ...completedOrders
                          .map(
                            (order) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: DetailedOrderCard(order: order),
                            ),
                          )
                          .toList(),

                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: () => context.push('/order-history'),
                        child: Text(
                          AppLocalizations.of(context)!.viewFullArchive,
                          style: const TextStyle(
                            color: Color(0xFF1E3932),
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
