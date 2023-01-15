import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/app_setting_repository.dart';
import 'package:rsapp/data/local/local_data_source.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/service/rs_service.dart';

// アプリ起動時の初期化処理を行う
final appInitStreamProvider = FutureProvider<void>((ref) async {
  await ref.read(rsServiceProvider).init();
  await ref.read(localDataSourceProvider).init();
  await ref.read(characterProvider.notifier).init();

  await ref.read(appSettingsProvider.notifier).refresh();
});

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    // TODO これよくないのでこのNotifierをやめてappInitStreamProviderでAppSettingsの初期値を取得するようにする
    return const AppSettings(currentMode: ThemeMode.light, characterListOrderType: CharacterListOrderType.status);
  }

  Future<void> refresh() async {
    final isDarkMode = await ref.read(appSettingsRepositoryProvider).isDarkMode();
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    final index = await ref.read(appSettingsRepositoryProvider).getCaracterListOrderIndex();
    final type = AppSettings.toType(index);

    state = AppSettings(currentMode: mode, characterListOrderType: type);
  }

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await ref.read(appSettingsRepositoryProvider).changeDarkMode();
    } else {
      await ref.read(appSettingsRepositoryProvider).changeLightMode();
    }
    await refresh();
  }

  Future<void> setCharacterListOrder(CharacterListOrderType type) async {
    await ref.read(appSettingsRepositoryProvider).saveCharacterListOrderIndex(type.index);
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

extension Characters on List<Character> {
  List<Character> order(CharacterListOrderType orderType) {
    final newList = this;
    switch (orderType) {
      case CharacterListOrderType.hp:
        newList.sort((c1, c2) {
          final t = c2.myStatus?.hp ?? 0;
          final v = c1.myStatus?.hp ?? 0;
          return t.compareTo(v);
        });
        break;
      case CharacterListOrderType.production:
        newList.sort((c1, c2) => c1.id.compareTo(c2.id));
        break;
      case CharacterListOrderType.status:
        newList.sort((c1, c2) {
          final t = c2.myStatus?.sumWithoutHp() ?? 0;
          final v = c1.myStatus?.sumWithoutHp() ?? 0;
          return t.compareTo(v);
        });
        break;
    }
    return newList;
  }
}
