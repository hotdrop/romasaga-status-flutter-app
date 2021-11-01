import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = context.read(appSettingsProvider).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (isDark) async {
        await context.read(appSettingsProvider.notifier).setDarkMode(isDark);
        setState(() => _isDarkMode = !_isDarkMode);
      },
      value: _isDarkMode,
    );
  }
}
