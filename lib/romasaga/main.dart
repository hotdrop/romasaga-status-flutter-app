import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/top_page.dart';

import 'common/rs_colors.dart';
import 'common/rs_strings.dart';

void main() => runApp(RomasagaApp());

class RomasagaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 日本語フォントが適用されるように設定
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', ''),
      ],
      title: RSStrings.appTitle,
      theme: ThemeData.dark().copyWith(accentColor: RSColors.accent),
      home: TopPage(),
    );
  }
}
