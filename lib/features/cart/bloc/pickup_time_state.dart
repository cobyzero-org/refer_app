enum PickupTimeType { asap, scheduled }

class PickupTimeState {
  final PickupTimeType type;
  final DateTime? scheduledTime;
  final String waitTimeMessage;

  PickupTimeState({
    this.type = PickupTimeType.asap,
    this.scheduledTime,
    this.waitTimeMessage = '10-15 min wait',
  });

  PickupTimeState copyWith({
    PickupTimeType? type,
    DateTime? scheduledTime,
    String? waitTimeMessage,
  }) {
    return PickupTimeState(
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      waitTimeMessage: waitTimeMessage ?? this.waitTimeMessage,
    );
  }

  /// Hora efectiva de recogida: ahora para ASAP, la elegida para programados.
  DateTime? get effectivePickupTime =>
      type == PickupTimeType.asap ? DateTime.now() : scheduledTime;

  /// Los programados exigen una hora futura vigente al momento de pagar.
  bool get hasValidPickupTime =>
      type == PickupTimeType.asap ||
      (scheduledTime != null && scheduledTime!.isAfter(DateTime.now()));

  /// Valor listo para el API: RFC3339 con zona horaria.
  /// `toIso8601String()` en hora local no trae offset y el backend lo
  /// descarta; en UTC agrega `Z` y el parseo siempre funciona.
  String? toApiPickupTime() {
    final t = effectivePickupTime;
    if (t == null) return null;
    return t.toUtc().toIso8601String();
  }
}
