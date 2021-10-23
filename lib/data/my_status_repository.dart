import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rsapp/data/local/my_status_dao.dart';
import 'package:rsapp/data/remote/my_status_api.dart';
import 'package:rsapp/models/status.dart' show MyStatus;
import 'package:rsapp/common/rs_logger.dart';

final myStatusRepositoryProvider = Provider((ref) => _MyStatusRepository(ref.read));

class _MyStatusRepository {
  const _MyStatusRepository(this._read);

  final Reader _read;

  static const String _backupDateKey = 'backup_date_key';

  Future<List<MyStatus>> findAll() async {
    return await _read(myStatusDaoProvider).findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _read(myStatusDaoProvider).find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _read(myStatusDaoProvider).save(status);
  }

  Future<void> backup() async {
    final myStatuses = await findAll();
    await _read(myStatusApiProvider).save(myStatuses);
    await _saveBackupDate();
  }

  Future<void> restore() async {
    final myStatuses = await _read(myStatusApiProvider).findAll();
    RSLogger.d('データを取得しました。size=${myStatuses.length}');

    await _read(myStatusDaoProvider).refresh(myStatuses);
  }

  Future<String> getPreviousBackupDateStr() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dateStr = prefs.get(_backupDateKey) as String;
    return dateStr.substring(0, 10);
  }

  Future<void> _saveBackupDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nowDate = DateTime.now();
    await prefs.setString(_backupDateKey, nowDate.toString());
  }
}
