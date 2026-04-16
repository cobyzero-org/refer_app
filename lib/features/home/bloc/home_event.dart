abstract class HomeEvent {}

class HomeDataRequested extends HomeEvent {}

class UserProfileUpdated extends HomeEvent {
  final String name;
  final String email;
  final String? phoneNumber;
  final String? birthDate;

  UserProfileUpdated({
    required this.name,
    required this.email,
    this.phoneNumber,
    this.birthDate,
  });
}
