import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';

class RSTheme {
  RSTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: RSColors.themeColor,
    primaryColorDark: Colors.indigoAccent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: RSColors.themeColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RSColors.themeColor,
    ),
    backgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: RSColors.themeColor,
    primaryColorDark: Colors.indigoAccent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white30,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RSColors.themeColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
  );
}
