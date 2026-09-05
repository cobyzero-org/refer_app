abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashAuthenticated extends SplashState {
  /// Hay versión nueva en el API (aviso no bloqueante, ya mostrado en splash).
  final bool updateAvailable;
  final String latestVersion;

  SplashAuthenticated({this.updateAvailable = false, this.latestVersion = ''});
}

class SplashUnauthenticated extends SplashState {
  /// Hay versión nueva en el API (aviso no bloqueante, ya mostrado en splash).
  final bool updateAvailable;
  final String latestVersion;

  SplashUnauthenticated({this.updateAvailable = false, this.latestVersion = ''});
}

/// La instalada está por debajo de minVersion del API: bloqueo total
/// hasta actualizar. Navegar a `/update-required`.
class SplashForceUpdate extends SplashState {
  final String minVersion;
  final String installedVersion;

  SplashForceUpdate({required this.minVersion, required this.installedVersion});
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
