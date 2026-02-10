import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refer_app/core/constants/colors.dart';
import 'package:refer_app/features/home/home_screen.dart';
import 'package:refer_app/features/menu/ui/menu_view.dart';
import 'package:refer_app/features/navigator/app/cubit/navigator_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorScreen extends StatelessWidget {
  const NavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<NavigatorCubit, NavigatorCubitState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey, width: 0.5),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icon/u_star.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 0
                          ? theme.colorScheme.primary
                          : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icon/u_cup.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 1
                          ? theme.colorScheme.primary
                          : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Menú',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icon/u_credit-card.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 2
                          ? theme.colorScheme.primary
                          : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Rewards',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icon/u_location-point.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 3
                          ? theme.colorScheme.primary
                          : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Mi Perfil',
                ),
              ],
              currentIndex: state.selectedIndex,
              selectedItemColor: theme.colorScheme.primary,
              onTap: (index) {
                context.read<NavigatorCubit>().onItemTapped(index);
              },
            ),
          ),
          body: PageView(
            controller: state.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              MenuView(),
              SizedBox.shrink(),
              SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
