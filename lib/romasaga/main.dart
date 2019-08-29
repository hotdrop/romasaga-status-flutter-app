import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/char_list_view_model.dart';
import 'ui/top_page.dart';

import 'ui/widget/character_icon_loader.dart';

import 'common/rs_colors.dart';
import 'common/rs_strings.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(builder: (context) => CharListViewModel()..load()),
      Provider(builder: (_) => CharacterIconLoader()..init()),
    ],
    child: RomasagaApp(),
  ));
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
      title: RSStrings.AppTitle,
      theme: ThemeData.dark().copyWith(accentColor: RSColors.accent),
      home: TopPage(),
    );
  }
}
