import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_manager.dart';

class ApiClient {
  late Dio dio;
  final TokenManager tokenManager;

  ApiClient({required this.tokenManager}) {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'http://localhost:3000/api/v1', // Cambiar a 10.0.2.2 para Android Emulator
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
        onError: (DioException e, handler) async {
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
