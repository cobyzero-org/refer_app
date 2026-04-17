import '../../../core/api_client.dart';
import '../../../core/token_manager.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(String name, String email, String password, {bool keepUpdated = false});
  Future<bool> validateToken();
  Future<void> logout();
  Future<bool> changePassword(String currentPassword, String newPassword);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  AuthRepositoryImpl({required this.apiClient, required this.tokenManager});

  @override
  Future<bool> validateToken() async {
    try {
      final token = await tokenManager.getAccessToken();
      if (token == null) return false;

      final response = await apiClient.dio.get('/auth/validate');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      await tokenManager.deleteTokens();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await tokenManager.deleteTokens();
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['accessToken'];
        if (token != null) {
          await tokenManager.saveTokens(accessToken: token);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signup(String name, String email, String password, {bool keepUpdated = false}) async {
    try {
      final response = await apiClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'keepUpdated': keepUpdated,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['accessToken'];
        if (token != null) {
          await tokenManager.saveTokens(accessToken: token);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await apiClient.dio.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
