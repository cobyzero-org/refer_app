import '../../../core/models/location.dart';

abstract class LocationsState {}

class LocationsInitial extends LocationsState {}

class LocationsLoading extends LocationsState {}

class LocationsLoaded extends LocationsState {
  final List<Location> locations;
  final Location? selectedLocation;

  LocationsLoaded({required this.locations, this.selectedLocation});

  LocationsLoaded copyWith({
    List<Location>? locations,
    Location? selectedLocation,
  }) {
    return LocationsLoaded(
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

class LocationsError extends LocationsState {
  final String message;
  LocationsError(this.message);
}
