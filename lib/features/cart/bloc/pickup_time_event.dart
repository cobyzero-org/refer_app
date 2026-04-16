import 'pickup_time_state.dart';

abstract class PickupTimeEvent {}

class PickupTimeTypeChanged extends PickupTimeEvent {
  final PickupTimeType type;
  PickupTimeTypeChanged(this.type);
}

class ScheduledTimeChanged extends PickupTimeEvent {
  final DateTime time;
  ScheduledTimeChanged(this.time);
}
