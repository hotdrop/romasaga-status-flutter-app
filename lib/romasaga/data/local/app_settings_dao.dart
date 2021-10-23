import 'package:rsapp/common/rs_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsDao {
  AppSettingsDao._();

  factory AppSettingsDao.create() {
    return _instance;
  }

  static final AppSettingsDao _instance = AppSettingsDao._();
  static const _darkModeKey = 'DARK_MODE';

  SharedPreferences _prefs;

  Future<void> init() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  bool isDarkMode() {
    if (_prefs.containsKey(_darkModeKey)) {
      RSLogger.i('sharedにダークモードのキーが保存されているのでそれを取得します。');
      return _prefs.getBool(_darkModeKey);
    } else {
      RSLogger.i('sharedにダークモードのキーが保存されていないのでライトモードと判定します。');
      return false;
    }
  }

  Future<void> saveDarkMode() async {
    RSLogger.i('ダークモードで保存します。');
    await _prefs.setBool(_darkModeKey, true);
  }

  Future<void> saveLightMode() async {
    RSLogger.i('ライトモードで保存します。');
    await _prefs.setBool(_darkModeKey, false);
  }
}
