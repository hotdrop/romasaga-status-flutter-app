import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => _SharedPrefs(ref.read));
final _sharefPregerencesProvider = Provider((ref) async => await SharedPreferences.getInstance());

class _SharedPrefs {
  const _SharedPrefs(this._read);

  final Reader _read;

  ///
  /// テーマモードの設定
  ///
  Future<bool> isDarkMode() async => await _getBool('key001', defaultValue: false);
  Future<void> saveDarkMode(bool value) async {
    await _saveBool('key001', value);
  }

  ///
  /// キャラ一覧のソート順
  ///
  Future<int> getCharacterOrder() async => await _getInt('key002');
  Future<void> saveCharacterOrder(int value) async {
    await _saveInt('key002', value);
  }

  ///
  /// バックアップの日付
  ///
  Future<String> getBackupDate() async => await _getString('key003');
  Future<void> saveBackupDate(String value) async {
    await _saveString('key003', value);
  }

  // 以下は型別のデータ格納/取得処理
  Future<String> _getString(String key) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getString(key) ?? '';
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setString(key, value);
  }

  Future<int> _getInt(String key) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getInt(key) ?? 0;
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setInt(key, value);
  }

  Future<bool> _getBool(String key, {required bool defaultValue}) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setBool(key, value);
  }
}
