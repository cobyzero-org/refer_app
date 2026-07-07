import 'dart:io';

class AppConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://127.0.0.1:3000';
  }

  static String get apiBaseUrl => '$baseUrl/api/v1';
  static String get socketUrl => '$baseUrl/cart';
}
