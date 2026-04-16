import 'package:flutter_bloc/flutter_bloc.dart';
import 'pickup_time_event.dart';
import 'pickup_time_state.dart';

class PickupTimeBloc extends Bloc<PickupTimeEvent, PickupTimeState> {
  PickupTimeBloc() : super(PickupTimeState()) {
    on<PickupTimeTypeChanged>((event, emit) {
      emit(state.copyWith(type: event.type));
    });
    on<ScheduledTimeChanged>((event, emit) {
      emit(state.copyWith(
        type: PickupTimeType.scheduled,
        scheduledTime: event.time,
      ));
    });
  }
}
