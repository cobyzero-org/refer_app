import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/core/constants/colors.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: AppColors.green,
    onPrimary: Colors.white,
    secondary: AppColors.gold,
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: AppColors.dark,
    error: Colors.redAccent,
  ),

  scaffoldBackgroundColor: AppColors.cream,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: AppColors.dark,
    ),
  ),

  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      color: AppColors.dark,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.green,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.dark,
    ),
    bodyLarge: TextStyle(
      fontSize: 15,
      height: 1.6,
      color: AppColors.dark.withOpacity(0.8),
    ),
    labelLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

final ThemeData themeDataDark = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: AppColors.green,
    secondary: AppColors.gold,
    background: const Color(0xFF121212),
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.gold,
    ),
    bodyLarge: TextStyle(fontSize: 15, height: 1.6, color: Colors.white70),
  ),
);
