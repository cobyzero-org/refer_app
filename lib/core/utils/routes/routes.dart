import 'package:go_router/go_router.dart';
import 'package:refer_app/features/detail/detail_screen.dart';
import 'package:refer_app/features/navigator/ui/navigator_screen.dart';
import 'package:refer_app/features/order/order_completed_scren.dart';
import 'package:refer_app/features/splash_screen.dart';

final routes = GoRouter(
  initialLocation: Routes.splash.path,
  routes: [
    GoRoute(
      path: Routes.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.navigator.path,
      builder: (context, state) => const NavigatorScreen(),
    ),
    GoRoute(
      path: Routes.detail.path,
      builder: (context, state) => const DetailScreen(),
    ),
    GoRoute(
      path: Routes.order.path,
      builder: (context, state) => const OrderCompletedScreen(),
    ),
  ],
);

enum Routes { splash, navigator, detail, order }

extension RoutesExtension on Routes {
  String get path {
    switch (this) {
      case Routes.splash:
        return '/splash';
      case Routes.navigator:
        return '/navigator';
      case Routes.detail:
        return '/detail';
      case Routes.order:
        return '/order';
    }
  }
}
