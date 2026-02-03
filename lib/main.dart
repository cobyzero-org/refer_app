import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refer_app/core/utils/routes/routes.dart';
import 'package:refer_app/features/navigator/app/cubit/navigator_cubit.dart';

import 'core/constants/app_theme.dart';
import 'core/constants/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  runApp(const MyApp());
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => NavigatorCubit())],
      child: MaterialApp.router(
        color: AppColors.background,
        debugShowCheckedModeBanner: false,
        title: 'Refer App',
        theme: themeData,
        darkTheme: themeDataDark,
        themeMode: ThemeMode.system,
        routerConfig: routes,
      ),
    );
  }
}
