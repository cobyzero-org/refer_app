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
}
