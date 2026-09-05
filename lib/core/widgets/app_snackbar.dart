import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Tipos de snackbar del sistema de diseño global.
///
/// - [AppSnackType.success]: confirmaciones (fondo pino, icono check).
/// - [AppSnackType.error]: bloqueos y fallos (fondo ladrillo, icono error).
/// - [AppSnackType.info]: avisos neutros / progreso (fondo tinta, icono info).
enum AppSnackType { success, error, info }

/// Snackbar global de la app — Sensory Editorial.
///
/// Un único diseño para toda la app: pill flotante, radio 14, icono en
/// círculo tintado + mensaje Outfit 14/w500. Sin gradientes, sin sombras
/// extra, sin radios múltiples.
///
/// Uso con context (reemplazo directo de `ScaffoldMessenger.of(...).showSnackBar`):
/// ```dart
/// AppSnackBar.success(context, l10n.profileUpdated);
/// AppSnackBar.error(context, state.message);
/// AppSnackBar.info(context, 'support@referapp.com');
/// ```
///
/// Uso sin context (blocs, repos, callbacks):
/// ```dart
/// AppSnackBar.show('Mensaje', type: AppSnackType.error);
/// ```
/// Requiere `scaffoldMessengerKey: AppSnackBar.messengerKey` en el
/// `MaterialApp` (ya cableado en `main.dart`).
class AppSnackBar {
  const AppSnackBar._();

  /// Key global del [ScaffoldMessenger] — permite mostrar snackbars sin context.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const _radius = 14.0;
  static const _margin = EdgeInsets.all(16);
  static const _padding = EdgeInsets.symmetric(horizontal: 14, vertical: 13);

  static Color _background(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
        return AppColors.primary;
      case AppSnackType.error:
        return AppColors.error;
      case AppSnackType.info:
        return AppColors.text;
    }
  }

  static IconData _icon(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
        return Icons.check_circle_outline_rounded;
      case AppSnackType.error:
        return Icons.error_outline_rounded;
      case AppSnackType.info:
        return Icons.info_outline_rounded;
    }
  }

  static Duration _duration(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
      case AppSnackType.info:
        return const Duration(seconds: 3);
      case AppSnackType.error:
        return const Duration(seconds: 4);
    }
  }

  static void _haptic(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
      case AppSnackType.info:
        HapticFeedback.lightImpact();
      case AppSnackType.error:
        HapticFeedback.heavyImpact();
    }
  }

  static SnackBar buildSnackBar(
    String message, {
    AppSnackType type = AppSnackType.info,
    Duration? duration,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _background(type),
      duration: duration ?? _duration(type),
      margin: _margin,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      content: Semantics(
        liveRegion: true,
        label: message,
        child: Padding(
          padding: _padding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon(type), color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra un snackbar usando el [context] dado.
  static void show(
    BuildContext context,
    String message, {
    AppSnackType type = AppSnackType.info,
    Duration? duration,
  }) {
    _haptic(type);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      buildSnackBar(message, type: type, duration: duration),
    );
  }

  /// Muestra un snackbar sin context, vía [messengerKey].
  /// No-op si el messenger aún no está montado.
  static void showGlobal(
    String message, {
    AppSnackType type = AppSnackType.info,
    Duration? duration,
  }) {
    final state = messengerKey.currentState;
    if (state == null) return;
    _haptic(type);
    state.hideCurrentSnackBar();
    state.showSnackBar(
      buildSnackBar(message, type: type, duration: duration),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, type: AppSnackType.success);

  static void error(BuildContext context, String message) =>
      show(context, message, type: AppSnackType.error);

  static void info(BuildContext context, String message) =>
      show(context, message, type: AppSnackType.info);
}
