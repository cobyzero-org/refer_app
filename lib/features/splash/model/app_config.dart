class AppConfig {
  final String version;
  final String minVersion;
  final bool maintenance;
  final Map<String, bool> features;
  final Map<String, String> endpoints;

  AppConfig({
    required this.version,
    required this.minVersion,
    required this.maintenance,
    required this.features,
    required this.endpoints,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      version: json['version'] ?? '',
      minVersion: json['minVersion'] ?? '',
      maintenance: json['maintenance'] ?? false,
      features: Map<String, bool>.from(json['features'] ?? {}),
      endpoints: Map<String, String>.from(json['endpoints'] ?? {}),
    );
  }
}
