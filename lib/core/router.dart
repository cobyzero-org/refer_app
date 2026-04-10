import 'package:go_router/go_router.dart';
import '../features/splash/ui/splash_screen.dart';
import '../features/splash/ui/maintenance_screen.dart';
import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/signup_screen.dart';
import '../features/navigator/ui/main_navigator.dart';
import '../features/product_details/ui/product_details_screen.dart';
import '../core/models/product.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainNavigator(),
    ),
    GoRoute(
      path: '/home', // Alias commonly used
      builder: (context, state) => const MainNavigator(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsScreen(product: product);
      },
    ),
  ],
);
