import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../home/ui/home_screen.dart';
import '../../stars/ui/stars_screen.dart';
import '../../orders/ui/orders_screen.dart';
import '../../settings/ui/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/locations_bloc.dart';
import '../../cart/bloc/locations_event.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StarsScreen(),
    const OrdersScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Lazy load: solo inicializar los blocs cuando entramos aquí (después de auth).
    context.read<HomeBloc>().add(HomeDataRequested());
    context.read<CartBloc>().add(CartStarted());
    context.read<LocationsBloc>().add(LocationsStarted());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: GlassTabBar.bottom(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) =>
                    setState(() => _selectedIndex = index),
                quality: GlassQuality.premium,
                tabs: [
                  GlassTab(
                    icon: Icon(
                      _selectedIndex == 0
                          ? Icons.home_filled
                          : Icons.home_outlined,
                    ),
                    label: l10n.home,
                  ),
                  GlassTab(
                    icon: Icon(
                      _selectedIndex == 1
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                    ),
                    label: l10n.stars,
                  ),
                  GlassTab(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.receipt_long_rounded
                          : Icons.receipt_long_outlined,
                    ),
                    label: l10n.orders,
                  ),
                  GlassTab(
                    icon: Icon(
                      _selectedIndex == 3
                          ? Icons.settings_rounded
                          : Icons.settings_outlined,
                    ),
                    label: l10n.settings,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
