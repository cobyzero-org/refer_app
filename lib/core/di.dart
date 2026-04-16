import 'package:get_it/get_it.dart';
import 'package:refer_app/features/cart/bloc/locations_event.dart';
import 'package:refer_app/features/cart/repository/locations_repository.dart';
import 'package:refer_app/features/stars/repository/stars_repository.dart';
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
import '../features/cart/bloc/locations_bloc.dart';
import '../features/cart/bloc/pickup_time_bloc.dart';
import 'services/stripe_service.dart';

import '../features/orders/repository/orders_repository.dart';
import '../features/orders/repository/orders_socket_manager.dart';
import '../features/orders/bloc/orders_bloc.dart';
import '../features/stars/bloc/stars_bloc.dart';
import '../features/search/repository/search_repository.dart';
import '../features/search/bloc/search_bloc.dart';

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
  sl.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<StripeService>(() => StripeService(apiClient: sl()));
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<OrdersSocketManager>(
    () => OrdersSocketManager(tokenManager: sl()),
  );
  sl.registerLazySingleton<StarsRepository>(
    () => StarsRepository(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(apiClient: sl()),
  );

  // BLoC
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => SplashBloc(sl(), sl()));
  sl.registerLazySingleton(() => HomeBloc(sl()));
  sl.registerFactory(() => ProductDetailsBloc(sl()));
  sl.registerLazySingleton(() => CartBloc(sl())..add(CartStarted()));
  sl.registerLazySingleton(
    () => LocationsBloc(repository: sl())..add(LocationsStarted()),
  );
  sl.registerFactory(() => PickupTimeBloc());
  sl.registerFactory(
    () => OrdersBloc(ordersRepository: sl(), socketManager: sl()),
  );
  sl.registerFactory(() => StarsBloc(sl()));
  sl.registerFactory(() => SearchBloc(searchRepository: sl()));
}
