class AppConfig {
  final String version;
  final String minVersion;
  final bool maintenance;
  final Map<String, bool> features;
  final Map<String, String> endpoints;
  final Map<String, String> settings;

  /// Monedas aceptadas por el API (SupportedCurrencies en refer_api).
  static const supportedCurrencies = {
    'USD', 'MXN', 'EUR', 'COP', 'PEN', 'CLP', 'ARS', 'BRL', 'GBP', 'CAD',
  };

  AppConfig({
    required this.version,
    required this.minVersion,
    required this.maintenance,
    required this.features,
    required this.endpoints,
    this.settings = const {},
  });

  /// Tipo de moneda configurado por el operador (tabla app_settings).
  /// Si falta o no es soportada, cae a USD.
  String get currency {
    final c = (settings['currency'] ?? 'USD').toUpperCase();
    return supportedCurrencies.contains(c) ? c : 'USD';
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      version: json['version'] ?? '',
      minVersion: json['minVersion'] ?? '',
      maintenance: json['maintenance'] ?? false,
      features: Map<String, bool>.from(json['features'] ?? {}),
      endpoints: Map<String, String>.from(json['endpoints'] ?? {}),
      settings: Map<String, String>.from(json['settings'] ?? {}),
    );
  }
}
