import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/characters/char_list_view_model.dart';
import 'ui/top_page.dart';

import 'common/rs_colors.dart';
import 'common/rs_strings.dart';

void main() {
  return runApp(
    ChangeNotifierProvider(
      builder: (context) => CharListViewModel()..load(),
      child: RomasagaApp(),
    ),
  );
}

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
