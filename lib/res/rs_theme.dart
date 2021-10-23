import 'package:flutter/material.dart';

class RSTheme {
  RSTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.lightBlue,
    primaryColorDark: Colors.indigoAccent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlue,
    ),
    backgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white30,
    ),
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
  );
}
