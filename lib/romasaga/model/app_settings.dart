import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/data/app_setting_repository.dart';

class AppSettings extends foundation.ChangeNotifier {
  AppSettings(this._repo);

  final AppSettingRepository _repo;

  bool get isDarkMode => _repo.isDarkMode();

  Future<void> setDarkMode(bool isDark) async {
    if (isDark) {
      await _repo.changeDarkMode();
    } else {
      await _repo.changeLightMode();
    }
    notifyListeners();
  }
}
