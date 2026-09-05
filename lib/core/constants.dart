import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String _env(String key) => dotenv.env[key]?.trim() ?? '';

  /// Entorno activo definido en .env: `ENV=dev | prod`.
  /// Acepta: dev / development / prod / production (case-insensitive).
  /// Cualquier otro valor (o vacío) => dev.
  static String get environment {
    final v = _env('ENV').toLowerCase();
    if (v == 'prod' || v == 'production') return 'prod';
    return 'dev';
  }

  static bool get isProd => environment == 'prod';
  static bool get isDev => !isProd;

  static bool get _isAndroid {
    try {
      return Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  static String get baseUrl {
    // 1. Variables por entorno (nuevo esquema)
    final envKey = isProd ? 'PROD_BASE_URL_ANDROID' : 'DEV_BASE_URL_ANDROID';
    if (_isAndroid) {
      final v = _env(envKey);
      if (v.isNotEmpty) return v.replaceAll(RegExp(r'/+$'), '');
    }
    final mainKey = isProd ? 'PROD_BASE_URL' : 'DEV_BASE_URL';
    final v = _env(mainKey);
    if (v.isNotEmpty) return v.replaceAll(RegExp(r'/+$'), '');

    // 2. Fallback: esquema anterior (BASE_URL / BASE_URL_ANDROID)
    if (_isAndroid) {
      final legacy = _env('BASE_URL_ANDROID');
      if (legacy.isNotEmpty) return legacy.replaceAll(RegExp(r'/+$'), '');
    }
    final legacy = _env('BASE_URL');
    if (legacy.isNotEmpty) return legacy.replaceAll(RegExp(r'/+$'), '');

    // 3. Defaults por plataforma
    if (_isAndroid) return 'http://10.0.2.2:3000';
    return 'http://127.0.0.1:3000';
  }

  static String get apiBaseUrl => '$baseUrl/api';

  static String get socketUrl => '$baseUrl/cart';

  static String get ordersSocketUrl => '$baseUrl/orders';
}

/// Formato de dinero según la moneda configurada en el API
/// (tabla app_settings -> GET /config -> settings.currency).
class Money {
  static const _symbols = {
    'USD': '\$',
    'MXN': '\$',
    'COP': '\$',
    'CLP': '\$',
    'ARS': '\$',
    'CAD': '\$',
    'EUR': '€',
    'GBP': '£',
    'BRL': 'R\$',
    'PEN': 'S/',
  };

  /// Código ISO (USD, MXN, ...) traído del API (GET /config).
  /// Lo actualiza SplashBloc al cargar; USD hasta entonces.
  static String currencyCode = 'USD';

  static String get symbol => _symbols[currencyCode] ?? '\$';

  /// Código en minúsculas para Stripe / backend.
  static String get stripeCurrency => currencyCode.toLowerCase();

  static String format(num amount) => '$symbol${amount.toStringAsFixed(2)}';

  static String formatPlus(num amount) => '+$symbol${amount.toStringAsFixed(2)}';
}

/// Impuesto estimado del pedido, configurado por el operador en la web
/// (tabla app_settings -> GET /config -> settings.tax_enabled/tax_rate).
class TaxConfig {
  /// Si se cobra impuesto. Lo actualiza SplashBloc al cargar.
  static bool enabled = true;

  /// Tasa como fracción 0..1 (0.08 = 8%). La actualiza SplashBloc.
  static double rate = 0.08;

  /// Tasa efectiva: 0 si el impuesto está apagado.
  static double get effectiveRate => enabled ? rate : 0;

  /// Total con impuesto incluido.
  static double applyTo(double subtotal) => subtotal * (1 + effectiveRate);

  /// Etiqueta "8%" para mostrar junto al nombre del impuesto.
  static String get percentLabel {
    final pct = effectiveRate * 100;
    return pct % 1 == 0 ? '${pct.toInt()}%' : '${pct.toStringAsFixed(1)}%';
  }
}

/// Tarifa de servicio del pedido, configurada por el operador en la web
/// (tabla app_settings -> GET /config -> settings.service_fee_rate).
class ServiceFee {
  /// Tasa como fracción 0..1 (0.05 = 5%). La actualiza SplashBloc.
  static double rate = 0.0;

  /// Monto de la tarifa sobre el subtotal.
  static double amountFor(double subtotal) => subtotal * rate;
}
