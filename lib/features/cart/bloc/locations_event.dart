import '../../../core/models/location.dart';

abstract class LocationsEvent {}

class LocationsStarted extends LocationsEvent {}

class LocationSelected extends LocationsEvent {
  final Location location;
  LocationSelected(this.location);
}
