import 'package:flutter/material.dart';

class RSTheme {
  RSTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.indigo,
    primaryColorDark: Colors.indigoAccent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.indigo,
    ),
  );

  static const darkThemeColor = Color.fromARGB(255, 204, 153, 255);
  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: darkThemeColor,
    indicatorColor: darkThemeColor,
    primaryColorDark: Colors.indigoAccent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: darkThemeColor,
      unselectedLabelColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkThemeColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkThemeColor,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: darkThemeColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkThemeColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: darkThemeColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
  );
}
