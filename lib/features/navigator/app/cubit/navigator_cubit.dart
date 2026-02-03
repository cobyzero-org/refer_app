import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigator_state.dart';

class NavigatorCubit extends Cubit<NavigatorCubitState> {
  NavigatorCubit()
    : super(
        NavigatorCubitState(selectedIndex: 0, pageController: PageController()),
      );

  void onItemTapped(int index) {
    state.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    emit(
      NavigatorCubitState(
        selectedIndex: index,
        pageController: state.pageController,
      ),
    );
  }
}
