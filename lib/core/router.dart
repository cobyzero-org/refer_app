import 'package:go_router/go_router.dart';
import '../features/splash/ui/splash_screen.dart';
import '../features/auth/ui/auth_screen.dart';
import '../features/auth/ui/signup_screen.dart';
import '../features/navigator/ui/main_navigator.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
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
  ],
);
