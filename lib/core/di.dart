import 'package:get_it/get_it.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/splash/bloc/splash_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

void initDI() {
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // BLoC
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => SplashBloc());
}
