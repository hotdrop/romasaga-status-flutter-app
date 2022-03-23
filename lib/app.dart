import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_theme.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/top_page.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsProvider).isDarkMode;
    final initFutureProvider = ref.watch(appInitStreamProvider);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: RSStrings.appTitle,
      theme: isDarkMode ? RSTheme.dark : RSTheme.light,
      home: initFutureProvider.when(
        data: (_) => const TopPage(),
        error: (e, s) {
          Future<void>.delayed(Duration.zero).then((_) => AppDialog.onlyOk(message: '$e'));
          return const Center(child: CircularProgressIndicator());
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
