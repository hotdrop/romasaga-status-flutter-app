import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_theme.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/start/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final isDarkMode = watch(appSettingsProvider).isDarkMode;
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja', '')],
        title: RSStrings.appTitle,
        theme: isDarkMode ? RSTheme.dark : RSTheme.light,
        home: const SplashPage(),
      );
    });
  }
}