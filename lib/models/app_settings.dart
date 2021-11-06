import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/app_setting_repository.dart';
import 'package:rsapp/data/local/local_data_source.dart';
import 'package:rsapp/service/rs_service.dart';

final appSettingsProvider = StateNotifierProvider<_AppSettingsNotifier, AppSettings>((ref) => _AppSettingsNotifier(ref.read));

class _AppSettingsNotifier extends StateNotifier<AppSettings> {
  _AppSettingsNotifier(this._read) : super(const AppSettings());

  final Reader _read;

  ///
  /// アプリ起動時に一回だけ呼ぶ
  ///
  Future<void> init() async {
    await _read(rsServiceProvider).init();
    await _read(localDataSourceProvider).init();
    await refresh();
  }

  Future<void> refresh() async {
    final isDarkMode = await _read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    final index = await _read(appSettingsRepositoryProvider).getCaracterListOrderIndex();
    final type = AppSettings.toType(index);

    state = AppSettings(currentMode: mode, characterListOrderType: type);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await _read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await _read(appSettingsRepositoryProvider).changeLightMode();
    }
    await refresh();
  }

  Future<void> setCharacterListOrder(CharacterListOrderType type) async {
    await _read(appSettingsRepositoryProvider).saveCharacterListOrderIndex(type.index);
    state = state.copyWith(characterListOrderType: type);
  }
}

class AppSettings {
  const AppSettings({
    this.currentMode = ThemeMode.system,
    this.characterListOrderType = CharacterListOrderType.status,
  });

  final ThemeMode currentMode;
  final CharacterListOrderType characterListOrderType;

  bool get isDarkMode => currentMode == ThemeMode.dark;

  static CharacterListOrderType toType(int index) {
    if (index == CharacterListOrderType.status.index) {
      return CharacterListOrderType.status;
    } else if (index == CharacterListOrderType.hp.index) {
      return CharacterListOrderType.hp;
    } else {
      return CharacterListOrderType.production;
    }
  }

  AppSettings copyWith({
    ThemeMode? currentMode,
    CharacterListOrderType? characterListOrderType,
  }) {
    return AppSettings(
      currentMode: currentMode ?? this.currentMode,
      characterListOrderType: characterListOrderType ?? this.characterListOrderType,
    );
  }
}

enum CharacterListOrderType { status, hp, production }
