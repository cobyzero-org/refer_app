import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final success = await _repository.login(event.email, event.password);
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final success = await _repository.signup(
        event.name,
        event.email,
        event.password,
        keepUpdated: event.keepUpdated,
      );
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Error creating account"));
      }
    });
  }
}
