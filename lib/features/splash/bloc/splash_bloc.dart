import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/repository/auth_repository.dart';
import '../repository/app_config_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;
  final AppConfigRepository _configRepository;

  SplashBloc(this._authRepository, this._configRepository) : super(SplashInitial()) {
    on<SplashStarted>((event, emit) async {
      // 1. Fetch App Config
      final config = await _configRepository.getConfig();
      
      // 2. Artificial delay for branding
      await Future.delayed(const Duration(seconds: 2));

      if (config != null && config.maintenance) {
        emit(SplashError("System is under maintenance"));
        return;
      }

      // 3. Validate Session
      final isValid = await _authRepository.validateToken();
      
      if (isValid) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }
}
