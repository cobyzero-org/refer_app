import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<HomeDataRequested>((event, emit) async {
      emit(HomeLoading());
      try {
        final results = await Future.wait([
          _repository.getProfile(),
          _repository.getSummary(),
          _repository.getSeasonalBrews(),
          _repository.getCategories(),
        ]);

        final user = results[0] as dynamic;
        final summary = results[1] as dynamic;
        final seasonalBrews = results[2] as dynamic;
        final categories = results[3] as dynamic;

        if (user != null && summary != null) {
          emit(HomeLoaded(
            user: user,
            summary: summary,
            seasonalBrews: seasonalBrews,
            categories: categories,
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
