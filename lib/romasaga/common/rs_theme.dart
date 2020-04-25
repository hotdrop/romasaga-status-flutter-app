import 'package:flutter/material.dart';

class RSTheme {
  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.lightBlue,
    accentColor: Colors.lightBlue,
    primaryColorDark: Colors.indigoAccent,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlue,
    ),
    backgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    accentColor: Colors.blueAccent,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white30,
    ),
    scaffoldBackgroundColor: Color(0xFF232323),
    applyElevationOverlayColor: true,
  );
}
