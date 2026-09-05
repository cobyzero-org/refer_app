import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Se lanza cuando el servidor está caído / inalcanzable.
/// Los repositorios la propagan y el [ServerHealth] la usa para
/// redirigir a la vista de mantenimiento (`/maintenance`).
class ServerDownException implements Exception {
  final String message;
  const ServerDownException([this.message = 'Server is unreachable']);

  @override
  String toString() => 'ServerDownException: $message';
}

/// Estado global de salud del servidor.
///
/// - [ApiClient] reporta aquí cada error de red/servidor.
/// - `main.dart` escucha [isDown] y navega a `/maintenance`.
/// - [MaintenanceScreen] limpia la bandera al reintentar.
class ServerHealth {
  ServerHealth._();

  /// `true` cuando se detectó que el servidor está caído.
  static final ValueNotifier<bool> isDown = ValueNotifier<bool>(false);

  static void reportDown() {
    if (!isDown.value) isDown.value = true;
  }

  static void markRecovered() {
    if (isDown.value) isDown.value = false;
  }

  /// `true` si el error indica servidor caído:
  /// sin conexión, timeouts, DNS/Socket, 503 o 5xx.
  static bool isServerDownError(Object error) {
    if (error is ServerDownException) return true;
    if (error is SocketException) return true;
    if (error is HttpException) return true;
    if (error is! DioException) return false;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        // 503 = en mantenimiento; 5xx = servidor caído.
        return status == 503 || (status >= 500 && status <= 599);
      case DioExceptionType.unknown:
        // Sin respuesta del servidor (apagado, DNS, red caída).
        if (error.response == null) return true;
        return error.error is SocketException || error.error is HttpException;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return false;
    }
  }
}
