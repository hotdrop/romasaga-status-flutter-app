import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';

class ThemeSwitch extends ConsumerStatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends ConsumerState<ThemeSwitch> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ref.read(appSettingsProvider).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (isDark) async {
        await ref.read(appSettingsProvider.notifier).setDarkMode(isDark);
        setState(() => _isDarkMode = !_isDarkMode);
      },
      value: _isDarkMode,
    );
  }
}
