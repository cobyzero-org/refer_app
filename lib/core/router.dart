import 'package:go_router/go_router.dart';
import 'package:refer_app/features/search/ui/search_screen.dart';
import '../features/splash/ui/splash_screen.dart';
import '../features/splash/ui/maintenance_screen.dart';
import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/signup_screen.dart';
import '../features/navigator/ui/main_navigator.dart';
import '../features/product_details/ui/product_details_screen.dart';
import '../features/cart/ui/cart_screen.dart';
import '../features/cart/ui/checkout_screen.dart';
import '../features/settings/ui/edit_profile_screen.dart';
import '../features/orders/ui/order_history_screen.dart';
import '../features/cart/ui/order_status_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/search/bloc/search_bloc.dart';
import '../features/search/bloc/search_event.dart';
import 'di.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/main', builder: (context, state) => const MainNavigator()),
    GoRoute(
      path: '/home', // Alias commonly used
      builder: (context, state) => const MainNavigator(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/search',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SearchBloc>()..add(FetchCategories()),
        child: const SearchScreen(),
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/order-history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/order-status',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? 'ER-9842';
        final locationName =
            state.uri.queryParameters['locationName'] ?? 'Downtown Studio';
        return OrderStatusScreen(orderId: orderId, locationName: locationName);
      },
    ),
  ],
);
