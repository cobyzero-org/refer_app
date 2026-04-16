import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/features/cart/bloc/locations_state.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/services/stripe_service.dart';
import 'package:refer_app/core/di.dart';
import 'package:refer_app/features/orders/repository/orders_repository.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../bloc/locations_bloc.dart';
import '../bloc/pickup_time_bloc.dart';
import '../bloc/pickup_time_state.dart';
import 'widgets/checkout_section_header.dart';
import 'widgets/pickup_location_card.dart';
import 'widgets/pickup_time_selector.dart';
import 'widgets/checkout_cart_items_list.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/place_order_button.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const double serviceFee = 1.70;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3932)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.checkout,
          style: const TextStyle(
            color: Color(0xFF1E3932),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          double total = 0;
          int itemCount = 0;
          if (state is CartLoaded) {
            total = state.total;
            itemCount = state.items.length;
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutSectionHeader(title: l10n.pickupLocation),
                    const SizedBox(height: 12),
                    const PickupLocationCard(),
                    const SizedBox(height: 32),

                    CheckoutSectionHeader(title: l10n.pickupTime),
                    const SizedBox(height: 12),
                    const PickupTimeSelector(),
                    const SizedBox(height: 32),

                    CheckoutSectionHeader(title: l10n.yourOrder),
                    const SizedBox(height: 12),
                    if (state is CartLoaded)
                      CheckoutCartItemsList(items: state.items),
                    const SizedBox(height: 32),

                    CheckoutSectionHeader(title: l10n.paymentMethod),
                    const SizedBox(height: 12),
                    const PaymentMethodCard(),
                    const SizedBox(height: 48),

                    OrderSummaryCard(
                      total: total,
                      itemCount: itemCount,
                      serviceFee: serviceFee,
                      items: state is CartLoaded ? state.items : [],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PlaceOrderButton(
                  total: total + serviceFee,
                  label: l10n.placeOrder,
                  onTap: () => _handlePlaceOrder(context, total, serviceFee),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handlePlaceOrder(
    BuildContext context,
    double total,
    double serviceFee,
  ) async {
    final amount = double.parse((total + serviceFee).toStringAsFixed(2));
    await _sendOrder(context, total, serviceFee, amount);
    return;
    await sl<StripeService>().makePayment(
      amount: amount,
      currency: 'usd',
      onSuccess: () async {},
      onError: (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red.shade800,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  Future<void> _sendOrder(
    BuildContext context,
    double total,
    double serviceFee,
    double amount,
  ) async {
    final locState = context.read<LocationsBloc>().state;
    final timeState = context.read<PickupTimeBloc>().state;
    final cartState = context.read<CartBloc>().state;

    if (cartState is! CartLoaded) return;

    String locationId = '';
    String locationName = 'Downtown Studio';
    if (locState is LocationsLoaded && locState.selectedLocation != null) {
      locationId = locState.selectedLocation!.id;
      locationName = locState.selectedLocation!.name;
    }

    final orderData = {
      'locationId': locationId,
      'total': amount,
      'serviceFee': serviceFee,
      'paymentMethod': 'STRIPE',
      'pickupTime': timeState.type == PickupTimeType.asap
          ? DateTime.now().toIso8601String()
          : timeState.scheduledTime?.toIso8601String(),
      'items': cartState.items.map((item) {
        return {
          'productId': item.id,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.totalPrice,
          'size': item.size,
          'type': item.type,
          'imageUrl': item.imageUrl,
        };
      }).toList(),
    };

    final orderResponse = await sl<OrdersRepository>().createOrder(orderData);

    if (context.mounted) {
      context.read<CartBloc>().add(CartCleared());
      final orderId = orderResponse?['orderNumber'] ?? '00000';
      context.go(
        '/order-status?orderId=$orderId&locationName=$locationName&userId=',
      );
    }
  }
}
