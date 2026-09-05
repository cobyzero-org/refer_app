import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'network/server_health.dart';
import 'token_manager.dart';
import 'constants.dart';

class ApiClient {
  late Dio dio;
  final TokenManager tokenManager;

  ApiClient({required this.tokenManager}) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenManager.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // El servidor respondió: ya no está caído.
          ServerHealth.markRecovered();
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Servidor caído / en mantenimiento: avisar al notificador
          // global para que la app muestre la vista de mantenimiento.
          if (ServerHealth.isServerDownError(e)) {
            ServerHealth.reportDown();
            return handler.next(e);
          }
          if (e.response?.statusCode == 401) {
            // Lógica para refresh token podría ir aquí
            await tokenManager.deleteTokens();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
