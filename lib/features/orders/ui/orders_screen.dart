import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../../../core/theme.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/active_order_card.dart';
import '../widgets/orders_header.dart';
import '../widgets/history_widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(OrdersStarted()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0, scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.orders, style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.2)),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) return _buildOrdersShimmer(context);
            if (state is OrdersFailure) {
              return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text(state.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                FilledButton(onPressed: () => context.read<OrdersBloc>().add(OrdersStarted()), child: const Text('Try again')),
              ])));
            }
            if (state is OrdersLoaded) {
              final activeOrders = state.orders.where((o) => ['ORDERED', 'PREPARING', 'READY'].contains(o['status'])).toList();
              final completedOrders = state.orders.where((o) => ['COMPLETED', 'CANCELLED'].contains(o['status'])).take(3).toList();
              final bottomPadding = MediaQuery.of(context).padding.bottom + 88;

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => context.read<OrdersBloc>().add(OrdersStarted()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const OrdersHeader(),
                    if (activeOrders.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Semantics(header: true, child: Text(AppLocalizations.of(context)!.activeOrders, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(999)),
                          child: Text(AppLocalizations.of(context)!.activeCount(activeOrders.length), style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      ...activeOrders.map((o) => Padding(padding: const EdgeInsets.only(bottom: 12), child: ActiveOrderCard(order: o))),
                    ],
                    const SizedBox(height: 24),
                    Semantics(header: true, child: Text(AppLocalizations.of(context)!.orderHistory, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3))),
                    const SizedBox(height: 12),
                    if (completedOrders.isEmpty)
                      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.separator)), child: Text(AppLocalizations.of(context)!.noHistoryYet, textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13)))
                    else
                      ...completedOrders.map((o) => Padding(padding: const EdgeInsets.only(bottom: 10), child: DetailedOrderCard(order: o))),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => context.push('/order-history'),
                        style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                        child: Text(AppLocalizations.of(context)!.viewFullArchive, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ]),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersShimmer(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 160, height: 26, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 8), Container(width: 220, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
        ]),
        const SizedBox(height: 24),
        Shimmer.fromColors(
          baseColor: AppColors.separator, highlightColor: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 130, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 12),
            Container(width: double.infinity, height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 24),
            Container(width: 120, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 12),
            ...List.generate(2, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(width: double.infinity, height: 92, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))))),
          ]),
        ),
      ]),
    );
  }
}
