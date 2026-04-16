import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../api_client.dart';

class StripeService {
  final ApiClient apiClient;
  // This matches the account seen in your logs (pi_3TMDysBVQCFU1ZTs...)
  static const String publishableKey =
      'pk_test_51OdiwLBVQCFU1ZTs1OsLhnEHt4NgzfpQ2O65r3vQsA6ZcPhNUIdXChcMYeNHiqE4wAM5lXyRPrhOoKBFB5UTcE9V00ddPMqfGS';

  StripeService({required this.apiClient});

  static Future<void> init() async {
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.example.refer_app';
    await Stripe.instance.applySettings();
  }

  Future<void> makePayment({
    required double amount,
    required String currency,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // 1. Create payment intent on the backend
      final response = await apiClient.dio.post(
        '/payments/create-payment-intent',
        data: {'amount': amount, 'currency': currency},
      );

      if (response.statusCode != 201) {
        onError('Failed to create payment intent');
        return;
      }

      final clientSecret = response.data['clientSecret'];

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Artisan Espresso',
          style: ThemeMode.light,
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. On success
      onSuccess();
    } catch (e) {
      if (e is StripeException) {
        onError(e.error.localizedMessage ?? 'Transaction cancelled');
      } else {
        onError(e.toString());
      }
    }
  }
}
