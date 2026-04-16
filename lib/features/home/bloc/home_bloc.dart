import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<UserProfileUpdated>((event, emit) async {
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(status: HomeStatus.loading));
        try {
          final updatedUser = await _repository.updateProfile({
            'name': event.name,
            'email': event.email,
            'phoneNumber': event.phoneNumber,
            'birthDate': event.birthDate,
          });

          if (updatedUser != null) {
            emit(currentState.copyWith(
              user: updatedUser,
              status: HomeStatus.success,
              message: "Profile updated successfully!",
            ));
            // Reset status after a small delay if needed, 
            // but usually success is enough for the UI to react
          } else {
            emit(currentState.copyWith(
              status: HomeStatus.error,
              message: "Failed to update profile",
            ));
          }
        } catch (e) {
          emit(currentState.copyWith(
            status: HomeStatus.error,
            message: e.toString(),
          ));
        }
      }
    });

    on<HomeDataRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        final results = await Future.wait([
          _repository.getProfile(),
          _repository.getSummary(),
          _repository.getSeasonalBrews(),
          _repository.getCategories(),
          _repository.getLatestProducts(),
        ]);

        final user = results[0] as dynamic;
        final summary = results[1] as dynamic;
        final seasonalBrews = results[2] as dynamic;
        final categories = results[3] as dynamic;
        final latestProducts = results[4] as dynamic;

        if (user != null && summary != null) {
          emit(HomeLoaded(
            user: user,
            summary: summary,
            seasonalBrews: seasonalBrews,
            categories: categories,
            latestProducts: latestProducts,
          ));
        } else {
          emit(HomeError("Failed to load dashboard data"));
        }
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
