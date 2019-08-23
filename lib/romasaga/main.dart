import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/rs_strings.dart';
import 'ui/char_list_view_model.dart';
import 'ui/top_page.dart';

void main() {
  return runApp(ChangeNotifierProvider<CharListViewModel>(
    builder: (context) => CharListViewModel()..load(),
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
      theme: ThemeData.dark().copyWith(accentColor: Colors.blue),
      home: TopPage(),
    );
  }
}
