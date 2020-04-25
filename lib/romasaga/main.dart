import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/common/rs_theme.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/data/app_setting_repository.dart';
import 'package:rsapp/romasaga/model/app_settings.dart';
import 'package:rsapp/romasaga/ui/top_page.dart';

void main() => runApp(RomasagaApp());

class RomasagaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettingRepository>(
      future: AppSettingRepository.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          RSLogger.d('初期化が終わっていません。');
          return _SplashScreen();
        } else {
          RSLogger.d('初期化完了です！');
          return ChangeNotifierProvider<AppSettings>(
            create: (_) => AppSettings(snapshot.data),
            child: _RomasagaApp(),
          );
        }
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _RomasagaApp extends StatelessWidget {
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
      theme: Provider.of<AppSettings>(context).isDarkMode ? RSTheme.dark : RSTheme.light,
      home: TopPage(),
    );
  }
}
