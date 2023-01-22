import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingRepository(ref));

class _AppSettingRepository {
  _AppSettingRepository(this._ref);

  final Ref _ref;

  Future<bool> isDarkMode() async {
    return await _ref.read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> changeDarkMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(true);
  }

  Future<void> changeLightMode() async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(false);
  }

  Future<int> getCaracterListOrderIndex() async {
    return await _ref.read(sharedPrefsProvider).getCharacterOrder();
  }

  Future<void> saveCharacterListOrderIndex(int index) async {
    await _ref.read(sharedPrefsProvider).saveCharacterOrder(index);
  }
}
