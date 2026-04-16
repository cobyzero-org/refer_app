import '../../../core/api_client.dart';
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
      return null;
    } catch (e) {
      return null;
    }
  }
}
