import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/app_setting_repository.dart';

final appSettingsProvider = StateNotifierProvider<_AppSettingsNotifier, AppSettings>((ref) => _AppSettingsNotifier(ref.read));

class _AppSettingsNotifier extends StateNotifier<AppSettings> {
  _AppSettingsNotifier(this._read) : super(const AppSettings());

  final Reader _read;

  Future<void> refresh() async {
    final isDarkMode = await _read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = AppSettings(currentMode: mode);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await _read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await _read(appSettingsRepositoryProvider).changeLightMode();
    }
    await refresh();
  }
}

class AppSettings {
  const AppSettings({this.currentMode = ThemeMode.system});

  final ThemeMode currentMode;
  bool get isDarkMode => currentMode == ThemeMode.dark;
}
