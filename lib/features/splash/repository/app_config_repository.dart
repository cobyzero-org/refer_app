import '../../../core/api_client.dart';
import '../../../core/network/server_health.dart';
import '../model/app_config.dart';

abstract class AppConfigRepository {
  Future<AppConfig?> getConfig();
  AppConfig? get cachedConfig;
}

class AppConfigRepositoryImpl implements AppConfigRepository {
  final ApiClient apiClient;
  AppConfig? _cachedConfig;

  AppConfigRepositoryImpl({required this.apiClient});

  @override
  AppConfig? get cachedConfig => _cachedConfig;

  @override
  Future<AppConfig?> getConfig() async {
    try {
      final response = await apiClient.dio.get('/config');
      if (response.statusCode == 200) {
        _cachedConfig = AppConfig.fromJson(response.data);
        return _cachedConfig;
      }
      // 503 / 5xx: el servidor está caído o en mantenimiento.
      if (response.statusCode == 503 ||
          ((response.statusCode ?? 0) >= 500)) {
        throw const ServerDownException('Server returned 5xx on /config');
      }
      return null;
    } on ServerDownException {
      rethrow;
    } catch (e) {
      // Sin conexión, timeouts, DNS, servidor apagado -> mantenimiento.
      if (ServerHealth.isServerDownError(e)) {
        throw ServerDownException(e.toString());
      }
      return null;
    }
  }
}
