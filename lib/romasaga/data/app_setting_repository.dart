import 'package:rsapp/romasaga/data/local/app_settings_dao.dart';

class AppSettingRepository {
  const AppSettingRepository._(this._dao);

  factory AppSettingRepository.create() {
    return AppSettingRepository._(AppSettingsDao.create());
  }

  final AppSettingsDao _dao;

  Future<void> load() async {
    await _dao.init();
  }

  bool isDarkMode() => _dao.isDarkMode();

  Future<void> changeDarkMode() async {
    await _dao.saveDarkMode();
  }

  Future<void> changeLightMode() async {
    await _dao.saveLightMode();
  }
}
