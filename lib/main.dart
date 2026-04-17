import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:refer_app/features/cart/bloc/pickup_time_bloc.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'core/theme.dart';
import 'core/di.dart';
import 'core/router.dart';
import 'core/bloc/locale_cubit.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/cart/bloc/locations_bloc.dart';
import 'core/services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StripeService.init();
  initDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<LocaleCubit>()),
        BlocProvider.value(value: sl<CartBloc>()),
        BlocProvider.value(value: sl<HomeBloc>()),
        BlocProvider.value(value: sl<LocationsBloc>()),
        BlocProvider(create: (context) => sl<PickupTimeBloc>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Artisan Espresso',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: router,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
