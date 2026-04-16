import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/locations_repository.dart';
import 'locations_event.dart';
import 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository repository;

  LocationsBloc({required this.repository}) : super(LocationsInitial()) {
    on<LocationsStarted>(_onLocationsStarted);
    on<LocationSelected>(_onLocationSelected);
  }

  Future<void> _onLocationsStarted(
    LocationsStarted event,
    Emitter<LocationsState> emit,
  ) async {
    emit(LocationsLoading());
    try {
      final locations = await repository.getLocations();
      emit(LocationsLoaded(
        locations: locations,
        selectedLocation: locations.isNotEmpty ? locations.first : null,
      ));
    } catch (e) {
      emit(LocationsError(e.toString()));
    }
  }

  void _onLocationSelected(
    LocationSelected event,
    Emitter<LocationsState> emit,
  ) {
    if (state is LocationsLoaded) {
      emit((state as LocationsLoaded).copyWith(selectedLocation: event.location));
    }
  }
}
