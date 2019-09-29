import 'package:shared_preferences/shared_preferences.dart';

import 'local/my_status_dao.dart';
import 'remote/my_status_api.dart';

import '../model/status.dart' show MyStatus;

import '../common/rs_logger.dart';

class MyStatusRepository {
  final MyStatusDao _localDataSource;
  final MyStatusApi _remoteDataSource;

  static String backupDateKey = 'backup_date_key';

  MyStatusRepository({MyStatusDao local, MyStatusApi remote})
      : _localDataSource = (local == null) ? MyStatusDao() : local,
        _remoteDataSource = (remote == null) ? MyStatusApi() : remote;

  Future<List<MyStatus>> findAll() async {
    return await _localDataSource.findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _localDataSource.find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }

  Future<void> backup() async {
    final myStatuses = await findAll();
    await _remoteDataSource.save(myStatuses);
    await _saveBackupDate();
  }

  Future<void> restore() async {
    final myStatuses = await _remoteDataSource.findAll();
    RSLogger.d('データを取得しました。size=${myStatuses.length}');

    _localDataSource.refresh(myStatuses);
  }

  Future<String> getPreviousBackupDateStr() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dateStr = prefs.get(backupDateKey);
    return dateStr?.substring(0, 10) ?? "-";
  }

  Future<void> _saveBackupDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nowDate = DateTime.now();
    await prefs.setString(backupDateKey, nowDate.toString());
  }
}
