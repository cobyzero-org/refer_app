import '../../../core/api_client.dart';
import '../model/app_config.dart';

abstract class AppConfigRepository {
  Future<AppConfig?> getConfig();
}

class AppConfigRepositoryImpl implements AppConfigRepository {
  final ApiClient apiClient;

  AppConfigRepositoryImpl({required this.apiClient});

  @override
  Future<AppConfig?> getConfig() async {
    try {
      final response = await apiClient.dio.get('/config');
      if (response.statusCode == 200) {
        return AppConfig.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
