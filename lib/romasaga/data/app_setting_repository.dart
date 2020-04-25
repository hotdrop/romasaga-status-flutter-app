import 'package:rsapp/romasaga/data/local/app_settings_dao.dart';

class AppSettingRepository {
  AppSettingRepository._();

  static Future<AppSettingRepository> getInstance() async {
    if (_instance == null) {
      _instance = AppSettingRepository._();
      await _instance.init();
    }
    return _instance;
  }

  static AppSettingRepository _instance;
  static AppSettingsDao _dao;

  Future<void> init() async {
    _dao = AppSettingsDao.create();
    await _dao.init();
  }

  bool isDarkMode() {
    if (_dao == null) {
      return false;
    } else {
      return _dao.isDarkMode();
    }
  }

  Future<void> changeDarkMode() async {
    await _dao.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _dao.saveLightMode();
  }
}
