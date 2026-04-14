import 'package:get_it/get_it.dart';
import 'token_manager.dart';
import 'api_client.dart';
import 'bloc/locale_cubit.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/splash/repository/app_config_repository.dart';
import '../features/home/repository/home_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/splash/bloc/splash_bloc.dart';
import '../features/home/bloc/home_bloc.dart';
import '../features/product_details/repository/product_repository.dart';
import '../features/product_details/bloc/product_details_bloc.dart';
import '../features/cart/repository/cart_repository.dart';
import '../features/cart/repository/cart_socket_manager.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../features/cart/bloc/cart_event.dart';

final sl = GetIt.instance; // sl = Service Locator

void initDI() {
  // Core
  sl.registerLazySingleton<TokenManager>(() => TokenManager());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(tokenManager: sl()));
  sl.registerSingleton<LocaleCubit>(LocaleCubit());

  // Repository
  sl.registerLazySingleton<AppConfigRepository>(
    () => AppConfigRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl(), tokenManager: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CartSocketManager>(
    () => CartSocketManager(tokenManager: sl()),
  );

  // BLoC
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => SplashBloc(sl(), sl()));
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => ProductDetailsBloc(sl()));
  sl.registerLazySingleton(() => CartBloc(sl())..add(CartStarted()));
}
