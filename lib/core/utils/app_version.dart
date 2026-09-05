import 'dart:io';

/// Resultado del chequeo de versión contra el API (GET /config).
enum UpdateStatus {
  /// Instalada >= version del API: todo en orden.
  ok,

  /// Instalada < version pero >= minVersion: aviso no bloqueante.
  soft,

  /// Instalada < minVersion: bloqueo hasta actualizar.
  force,
}

/// Config de tiendas. iOS necesita el ID numérico de App Store Connect;
/// se deja como constante para rellenar al publicar.
class AppUpdateConfig {
  const AppUpdateConfig._();

  /// ID numérico de la app en App Store (p. ej. "123456789").
  /// Vacío hasta publicar en iOS: en ese caso se muestra aviso en vez
  /// de intentar abrir la tienda.
  static const iosAppId = '';

  /// URL de la ficha en tienda según plataforma.
  /// Android usa el packageName (deep link válido sin más datos).
  static Uri? storeUri({required String packageName}) {
    if (Platform.isAndroid) {
      return Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );
    }
    if (Platform.isIOS && iosAppId.isNotEmpty) {
      return Uri.parse('https://apps.apple.com/app/id$iosAppId');
    }
    return null;
  }
}

/// Comparación y evaluación de versiones semver (`1.2.0`).
/// Partes faltantes cuentan como 0 (`1.2` == `1.2.0`).
/// Sufijos no numéricos se ignoran (`1.0.0+1` == `1.0.0`).
class AppVersion {
  const AppVersion._();

  /// -1 si [a] < [b], 0 si iguales, 1 si [a] > [b].
  static int compare(String a, String b) {
    final pa = _parts(a);
    final pb = _parts(b);
    final n = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < n; i++) {
      final va = i < pa.length ? pa[i] : 0;
      final vb = i < pb.length ? pb[i] : 0;
      if (va < vb) return -1;
      if (va > vb) return 1;
    }
    return 0;
  }

  static List<int> _parts(String v) {
    // Corta sufijos de build/metadata ("1.0.0+1", "1.0.0-beta").
    final core = v.trim().split(RegExp(r'[+-]')).first;
    return core.split('.').map((p) {
      final digits = RegExp(r'^\d+').stringMatch(p.trim()) ?? '';
      return int.tryParse(digits) ?? 0;
    }).toList();
  }

  /// Evalúa la versión instalada contra las del API.
  /// Si el API no trae versiones válidas, fail-open: [UpdateStatus.ok].
  static UpdateStatus status({
    required String installed,
    required String apiVersion,
    required String apiMinVersion,
  }) {
    if (installed.trim().isEmpty) return UpdateStatus.ok;
    if (compare(installed, apiMinVersion) < 0) return UpdateStatus.force;
    if (compare(installed, apiVersion) < 0) return UpdateStatus.soft;
    return UpdateStatus.ok;
  }
}
